# frozen_string_literal: true

gem 'dsfr-view-components'

environment 'require "dsfr/components"'

gem_group :development, :test do
  gem 'rspec-rails'
end

gem_group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'faker', require: false
  gem 'guard'
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'rubocop-capybara'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
  gem 'rspec'
end

generate 'rspec:install'
generate 'cucumber:install'

file 'Dockerfile.dev', <<~DOCKER
  FROM ruby:3.4.1-slim

  EXPOSE 3000

  RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y build-essential libpq-dev

  # do the bundle install in another directory with the strict essential
  # (Gemfile and Gemfile.lock) to allow further steps to be cached
  WORKDIR /bundle
  COPY Gemfile Gemfile.lock ./
  RUN bundle install

  # Move to the main folder
  WORKDIR /app

  COPY . .

  ENTRYPOINT ["./bin/docker-entrypoint"]

  CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
DOCKER

file 'docker-compose.yml', <<~COMPOSE
  services:
    web:
      build:
        dockerfile: Dockerfile.dev
      image: #{app_name}
      ports:
        - "3000:3000"
      volumes:
        - "./:/app"
        - "/app/node_modules"
COMPOSE

file 'Makefile', <<~MAKEFILE
  DOCKER-RUN = docker compose run -e TERM --rm --entrypoint=""
  BUNDLE-EXEC = bundle exec

  build:
  	docker compose build

  up:
  	docker compose up

  down:
  	docker compose down

  sh:
  	$(DOCKER-RUN) web bash

  lint:
  	$(DOCKER-RUN) web $(BUNDLE-EXEC) rubocop

  guard:
  	$(DOCKER-RUN) web $(BUNDLE-EXEC) guard

  debug:
  	$(DOCKER-RUN) web $(BUNDLE-EXEC) rdbg -A web 12345
MAKEFILE

file 'app/views/shared/_flash.html.erb', <<~ERB
  <% if flash.any? %>
    <div class="flash fr-mb-3w">
      <% if flash[:notice].present?  %>
        <div class="fr-alert fr-alert--info">
          <h3 class="fr-alert__title"><%= flash[:notice] %></h3>
        </div>
      <% end %>

      <% if flash[:alert].present?  %>
        <div class="fr-alert fr-alert--warning">
          <h3 class="fr-alert__title"><%= flash[:alert] %></h3>
        </div>
      <% end %>
    </div>
  <% end %>
ERB

file 'app/views/shared/_footer.html.erb', <<~ERB
  <footer class="fr-footer" role="contentinfo" id="footer">
    <div class="fr-container">
      <div class="fr-footer__body">
        <div class="fr-footer__brand fr-enlarge-link">
          <a href="/" title="Retour à l’accueil du site - #{app_name}">
            <p class="fr-logo">
              <%= t("global.service_name") %>
            </p>
          </a>
        </div>
        <div class="fr-footer__content">
          <p class="fr-footer__content-desc"><%= t("global.service_description") %></p>
          <ul class="fr-footer__content-list">
            <li class="fr-footer__content-item">
              <a class="fr-footer__content-link" target="_blank" href="https://legifrance.gouv.fr">legifrance.gouv.fr</a>
            </li>
            <li class="fr-footer__content-item">
              <a class="fr-footer__content-link" target="_blank" href="https://gouvernement.fr">gouvernement.fr</a>
            </li>
            <li class="fr-footer__content-item">
              <a class="fr-footer__content-link" target="_blank" href="https://service-public.fr">service-public.fr</a>
            </li>
            <li class="fr-footer__content-item">
              <a class="fr-footer__content-link" target="_blank" href="https://data.gouv.fr">data.gouv.fr</a>
            </li>
          </ul>
        </div>
      </div>
      <div class="fr-footer__bottom">
        <ul class="fr-footer__bottom-list">
          <li class="fr-footer__bottom-item">
            <a class="fr-footer__bottom-link" href="#">Plan du site</a>
          </li>
          <li class="fr-footer__bottom-item">
            <a class="fr-footer__bottom-link" href="#">Accessibilité : non/partiellement/totalement conforme</a>
          </li>
          <li class="fr-footer__bottom-item">
            <a class="fr-footer__bottom-link" href="#">Mentions légales</a>
          </li>
          <li class="fr-footer__bottom-item">
            <a class="fr-footer__bottom-link" href="#">Données personnelles</a>
          </li>
          <li class="fr-footer__bottom-item">
            <a class="fr-footer__bottom-link" href="#">Gestion des cookies</a>
          </li>
        </ul>
        <div class="fr-footer__bottom-copy">
          <p>Sauf mention contraire, tous les contenus de ce site sont sous <a href="https://github.com/etalab/licence-ouverte/blob/master/LO.md" target="_blank">licence etalab-2.0</a>
          </p>
        </div>
      </div>
    </div>
  </footer>
ERB

file 'app/views/shared/_header.html.erb', <<~ERB
  <%= dsfr_header logo_text: t("global.sponsor"), title: t("global.service_name"), tagline: t("global.service_description") do |header| %>
    <%= header.with_direct_link_simple title: "Accueil", path: root_path %>
  <% end %>
ERB

file 'app/views/shared/_menu.html.erb', <<~ERB
  <nav class="fr-nav" id="nav" role="navigation" aria-label="Menu principal">
    <ul class="fr-nav__list">
      <li class="fr-nav__item">
        <a class="fr-nav__link" href="#" target="_self" aria-current="page">accès direct</a>
      </li>
      <li class="fr-nav__item">
        <a class="fr-nav__link" href="#" target="_self">accès direct</a>
      </li>
      <li class="fr-nav__item">
        <a class="fr-nav__link" href="#" target="_self">accès direct</a>
      </li>
      <li class="fr-nav__item">
        <a class="fr-nav__link" href="#" target="_self">accès direct</a>
      </li>
    </ul>
  </nav>
ERB

file 'app/views/shared/_skiplinks.html.erb', <<~ERB
  <div class="fr-skiplinks">
    <nav class="fr-container" role="navigation" aria-label="Accès rapide">
      <ul class="fr-skiplinks__list">
        <li>
          <a class="fr-link" href="#main">Contenu</a>
        </li>
        <li>
          <a class="fr-link" href="#nav">Menu</a>
        </li>
        <li>
          <a class="fr-link" href="#footer">Pied de page</a>
        </li>
      </ul>
    </nav>
  </div>
ERB

file 'app/views/layouts/application.html.erb', <<~ERB
  <!DOCTYPE html>
  <html data-fr-scheme="system">
    <head>
      <title><%= yield(:page_title) if content_for?(:page_title) %> - <%= t("global.service_name") %></title>
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>

      <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
      <%= stylesheet_link_tag "dsfr.min", "application-turbo-track": "reload" %>

      <%= javascript_include_tag "dsfr.module.min.js", type: 'module' %>
      <%= javascript_include_tag "dsfr.nomodule.min.js", nomodule: true %>

      <%= javascript_importmap_tags %>
    </head>

    <body>
      <%= render 'shared/skiplinks' %>
      <%= render 'shared/header' %>

      <div class="fr-container">
        <main class="fr-py-2w" id="main">
          <%= render 'shared/flash' %>
          <%= yield %>
        </main>
      </div>

      <%= render 'shared/footer' %>
    </body>
  </html>
ERB

file 'config/locales/fr.yml', <<~YML
  fr:
    global:
      sponsor: "Direction\nInterministérielle\ndu Numérique"
      service_name: "#{app_name}"
      service_description: "Description de votre service"
YML

environment 'config.i18n.default_locale = :fr'

generate 'controller Home index'
route "root to: 'home#index'"

after_bundle do
  git :init
  git add: '.'
  git commit: [
    '-m "[rails-beta-template] initial commit" ',
    "-m 'birth tracker: https://github.com/betagouv/rails-template'"
  ].join
end
