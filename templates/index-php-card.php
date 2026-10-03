<?php
// OPTIONAL. Only if you have a launcher page (a PHP file with an $apps array, like
// https://wengindustries.com/trainer/). Append this entry before the closing `];`.
// href is relative to the launcher: "{{APP_SLUG}}/" for the php stack, "{{APP_SLUG}}/dist/" for vite.
// No launcher? Delete this file.
    [
        'name' => '{{APP_NAME}}',
        'eyebrow' => 'AGENT: three dot-separated nouns, e.g. Circuits · devices · smart home',
        'description' => 'AGENT: one sentence in the same voice as the existing cards.',
        'href' => '{{APP_HREF}}',
        'cta' => 'Open {{APP_NAME}}',
    ],
