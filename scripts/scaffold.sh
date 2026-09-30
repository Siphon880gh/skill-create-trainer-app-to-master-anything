#!/usr/bin/env bash
# Scaffold a new trainer app folder from templates/ and init it as its own git repo.
#
# Usage (run from the trainer/ root that holds index.php and the sibling apps):
#   bash .agents/skills/new-trainer-app/scripts/scaffold.sh <app-slug> "<App Name>" <CODENAME> "<topic>" [--stack php|vite] [--join-key familyId] [--dest <dir>]
#
# Example:
#   bash .agents/skills/new-trainer-app/scripts/scaffold.sh circuits-trainer "Circuits Trainer" CIRCUIT_CORE "electrical circuits for devices and smart homes" --stack php
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TPL="$SKILL_DIR/templates"

usage() { sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 1; }

[[ $# -ge 4 ]] || usage
APP_SLUG="$1"; APP_NAME="$2"; CODENAME="$3"; TOPIC="$4"; shift 4
STACK="php"; JOIN_KEY="familyId"; DEST="$(pwd)"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --stack)    STACK="$2"; shift 2 ;;
    --join-key) JOIN_KEY="$2"; shift 2 ;;
    --dest)     DEST="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; usage ;;
  esac
done

[[ "$APP_SLUG" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "app-slug must be kebab-case"; exit 1; }
[[ "$CODENAME" =~ ^[A-Z0-9_]+$ ]] || { echo "CODENAME must be UPPER_SNAKE"; exit 1; }

case "$STACK" in
  php)
    STACK_LABEL="Web (PHP 8.2 server-rendered + vanilla JS, localStorage; PHPUnit)"
    VERIFY_CMD="./vendor/bin/phpunit"
    RUN_CMD="php -S localhost:8080 router.php   # or composer serve once it exists"
    APP_HREF="$APP_SLUG/"
    ;;
  vite)
    STACK_LABEL="Web (React 19 + Vite + TypeScript; Vitest + ESLint; build to dist/)"
    VERIFY_CMD="npm run lint && npm run build"
    RUN_CMD="npm install && npm run dev"
    APP_HREF="$APP_SLUG/dist/"
    ;;
  *) echo "--stack must be php or vite"; exit 1 ;;
esac

PROGRESS_KEY="$(echo "$CODENAME" | tr '[:upper:]' '[:lower:]')_progress_v1"
DATE_ISO="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
APP_DIR="$DEST/$APP_SLUG"

[[ -e "$APP_DIR" ]] && { echo "Refusing to overwrite existing path: $APP_DIR"; exit 1; }
[[ -f "$DEST/index.php" ]] || echo "Warning: $DEST has no index.php; is this the trainer/ root?"

# Token substitution. Uses | as the sed delimiter; escape it in values.
esc() { printf '%s' "$1" | sed -e 's/[|&\\]/\\&/g'; }
subst() {
  sed \
    -e "s|{{APP_SLUG}}|$(esc "$APP_SLUG")|g" \
    -e "s|{{APP_NAME}}|$(esc "$APP_NAME")|g" \
    -e "s|{{CODENAME}}|$(esc "$CODENAME")|g" \
    -e "s|{{TOPIC}}|$(esc "$TOPIC")|g" \
    -e "s|{{STACK}}|$(esc "$STACK")|g" \
    -e "s|{{STACK_LABEL}}|$(esc "$STACK_LABEL")|g" \
    -e "s|{{VERIFY_CMD}}|$(esc "$VERIFY_CMD")|g" \
    -e "s|{{RUN_CMD}}|$(esc "$RUN_CMD")|g" \
    -e "s|{{APP_HREF}}|$(esc "$APP_HREF")|g" \
    -e "s|{{PROGRESS_KEY}}|$(esc "$PROGRESS_KEY")|g" \
    -e "s|{{JOIN_KEY}}|$(esc "$JOIN_KEY")|g" \
    -e "s|{{DATE_ISO}}|$(esc "$DATE_ISO")|g" \
    "$1" > "$2"
}

mkdir -p "$APP_DIR"/{.agents/skills,LOOPS,context/toc,context/notes,docs}

subst "$TPL/EPIC_MAP.md"                        "$APP_DIR/EPIC_MAP.md"
subst "$TPL/IMPLEMENTATION_STORIES.md"          "$APP_DIR/IMPLEMENTATION_STORIES.md"
subst "$TPL/RESOURCES.md"                       "$APP_DIR/RESOURCES.md"
subst "$TPL/README.md"                          "$APP_DIR/README.md"
subst "$TPL/impeccable.md"                      "$APP_DIR/.impeccable.md"
subst "$TPL/AGENTS_LOOP-Continue-Milestone.md"  "$APP_DIR/AGENTS_LOOP-Continue-Milestone.md"
subst "$TPL/state.json"                         "$APP_DIR/.agents/state.json"
subst "$TPL/LOOPS/README.md"                    "$APP_DIR/LOOPS/README.md"
subst "$TPL/LOOPS/LOOP-Graph.md"                "$APP_DIR/LOOPS/LOOP-Graph.md"
subst "$TPL/LOOPS/LOOP-Section.md"              "$APP_DIR/LOOPS/LOOP-Section.md"
subst "$TPL/context/README.md"                  "$APP_DIR/context/README.md"
subst "$TPL/context/clone.sh"                   "$APP_DIR/context/clone.sh"
subst "$TPL/gitignore"                          "$APP_DIR/.gitignore"
mkdir -p "$APP_DIR/.agents/skills/add-coaching-session"
subst "$TPL/agents-skills/add-unit/SKILL.md"    "$APP_DIR/.agents/skills/add-coaching-session/SKILL.md"
subst "$TPL/index-php-card.php"                 "$APP_DIR/docs/index-php-card.snippet.php"
chmod +x "$APP_DIR/context/clone.sh"
touch "$APP_DIR/context/toc/.gitkeep" "$APP_DIR/context/notes/.gitkeep"

(
  cd "$APP_DIR"
  git init -q -b main
  git add -A
  git -c user.useConfigOnly=false commit -q -m "Scaffold $APP_NAME ($CODENAME) from new-trainer-app skill" || true
)

cat <<EOF

Scaffolded: $APP_DIR
  stack        $STACK
  verify       $VERIFY_CMD
  join key     $JOIN_KEY
  progress key $PROGRESS_KEY
  root card    href => '$APP_HREF'  (snippet: docs/index-php-card.snippet.php)

Next (Phase 1 continues in SKILL.md from step 1.2):
  - Fill every <!-- agent: --> and AGENT: marker:
      grep -rn 'agent:' $APP_DIR --include='*.md' --include='*.json' --include='*.php' --include='*.sh' | wc -l
  - Copy LOOPS/LOOP-Section.md once per resource type, then delete it.
  - Add sources to context/clone.sh + context/README.md, run: bash context/clone.sh
  - Append docs/index-php-card.snippet.php into ../index.php \$apps
EOF
