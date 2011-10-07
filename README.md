# varnish-hit-stats

## Installing

    sudo easy_install Pygments
    sudo pacman -S rsync

## Usage

`vhs-init <jekyll dir>` copies initial Jekyll site source directory keeping _posts and _config.yml untouched

`vhs-process` generates stats in YAML output format from input Varnish NCSA log *special* file

`vhs-generate-posts <jekyll dir>` generates Jekyll post files from input YAML data

`vhs-publish <jekyll dir> <website dir>` generated website from Jekyll directory to given website directory

`vhs-cron` generate website to `/srv/http/stats` from `/var/log/varnish/varnishncsa.log.1`

Example:

    # initalize jekyll site
    vhs-init /var/lib/vhs/jekyll

    # generate posts
    cat /var/log/varnish/varnishncsa.log.1 | vhs-process > /var/lib/vhs/data/`date +%Y-%m-%d --date yesterday`.yml
    cat /var/lib/vhs/data/`date +%Y-%m-%d --date yesterday`.yml | vhs-generate-posts /var/lib/vhs/jekyll

    # or
    cat /var/log/varnish/varnishncsa.log.1 | vhs-process | vhs-generate-posts /var/lib/vhs/jekyll

    # publish
    vhs-publish /var/lib/vhs/jekyll /srv/http/stats

    # run all above
    vhs-cron

## Contributing to varnish-hit-stats
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Jakub Pastuszek. See LICENSE.txt for
further details.
