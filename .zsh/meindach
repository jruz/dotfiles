# vi:syntax=sh
alias md_migrate='dc run --rm backend rails db:migrate && dc run -e RAILS_ENV=test --rm backend rails db:migrate'
alias md_content='dc run -e ENABLE_CONTENTFUL=true --rm backend bundle exec rails content:persist'
alias md_licenses='dc run --rm backend rake gem:licenses:npm_dist[JS_LICENSES_DIST.csv]'
alias md_user='dc run --rm backend rails db:dummy_user'
alias md_reset='dc run --rm backend rails db:reset db:migrate db:dummy_user db:country_config'
