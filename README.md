# rails-beta-template

![example workflow](https://github.com/freesteph/new-rails-template/actions/workflows/ruby.yml/badge.svg)

![Capture d’écran 2025-01-21 à 01 32 00](https://github.com/user-attachments/assets/0c5f50ba-c970-465e-a402-3f88a4b17f2a)


Un template Rails opiniâtre pour démarrer une app avec le
[DSFR](https://www.systeme-de-design.gouv.fr/) et plein d'autres
goodies :

- RSpec pour les tests ;
- Cucumber/Capybara pour les tests BDD ;
- Rubocop ;
- Docker/Docker Compose ;
- notre [librairie de composants DSFR](https://github.com/betagouv/dsfr-view-components)
- voir toutes les batteries fournies dans [./template.rb](./template.rb).

L'ancienne version était un import brut d'une application par défaut
configurée avec Rails 7, puis Rails 8. Désormais l'utilisation d'un
véritable template permet les mêmes bénéfices sans se souder à une
version particulière : à quelques incertitudes près les nouvelles
versions de Rails ou des gems incluses sont immédiatement utilisables,
compatibles, voir les deux !

Le template [est testé sur Ubuntu/macOS, Ruby 3.2+ et Rails 7/8](https://github.com/freesteph/new-rails-template/actions/workflows/ruby.yml).

## Utilisation

Le minimum pour utiliser l'app consiste à lancer :

```sh
rails new -T -m "template.rb" name_of_the_app
```

Le `-T` désactive les tests qui sont installés par le template avec
RSpec. Le reste des options Rails (`rails new --help`) sont à votre
guise.
