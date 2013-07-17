# dontdieonme

"Don't die on me is" simple Ruby app that makes request to website every 2 minues.

- [Oto Brglez](https://github.com/otobrglez)

## Configuration

On Heroku set 2 variables one is for enviroment and one is url that has to be requested every 2 minutes.

    heroku config:set ENV=production URL_TO_GET=http://some-url-to-get.com/

Also scale Heroku to 1 worker!