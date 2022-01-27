<div align="center">
  <img src="https://user-images.githubusercontent.com/11348/151395659-3ebe29b6-b1d6-44fa-bb44-c42146c7e99a.png" width="563" />
  <p><strong>Killswitch</strong> is a clever control panel built by <a href="https://www.mirego.com">Mirego</a> that allows mobile developers to apply<br /> runtime version-specific behaviors to their iOS or Android application.</p>
  <a href="https://github.com/mirego/killswitch/actions/workflows/ci.yaml"><img src="https://github.com/mirego/killswitch/actions/workflows/ci.yaml/badge.svg" /></a><br /><br />
</div>

| Section                                 | Description                                            |
| --------------------------------------- | ------------------------------------------------------ |
| [🚧 Dependencies](#-dependencies)       | Technical dependencies and how to install them         |
| [🏎 Kickstart](#-kickstart)              | Details on how to kickstart development on the project |
| [🚑 Troubleshooting](#-troubleshooting) | Recurring problems and proven solutions                |
| [🚀 Deploy](#-deploy)                   | Deployment details for various enviroments             |

## 🚧 Dependencies

Every runtime dependencies are defined in the `.tool-versions` file. These external dependencies are also required:

- PostgreSQL (`~> 10.0`)

## 🏎 Kickstart

### Environment variables

All required environment variables are documented in [`.env.dev`](./.env.dev).

When running `rails`, `rake` or `make` commands, it is important that these variables are present in the environment. There are several ways to achieve this. Using [`nv`](https://github.com/jcouture/nv) is recommended since it works out of the box with `.env.*` files.

### Initial setup

1. Create both `.env.dev.local` and `.env.test.local` from empty values in [`.env.dev`](./.env.dev) and [`.env.test`](./.env.test)
2. Install Mix and NPM dependencies with `make dependencies`
3. Generate values for mandatory secrets in [`.env.dev`](./.env.dev) with `rake secret`

Then, with variables from `.env.dev` and `.env.dev.local` present in the environment:

4. Create and migrate the database with `rake db:setup`
5. Start the Phoenix server with `rails s`

### `make` commands

A `Makefile` is present at the root and expose common tasks. The list of these commands is available with `make help`.

### Tests

Tests can be ran with `make test`.

### Linting

Several linting and formatting tools can be ran to ensure coding style consistency:

- `make lint` ensures code follows our guidelines and best practices
- `make format` formats files using Prettier

### Continuous integration

The `.github/workflows/ci.yaml` workflow ensures that the codebase is in good shape on each pull request and branch push.

## 🚑 Troubleshooting

### System readiness

The project exposes a `GET /ping` route that sends an HTTP `200 OK` response as soon as the server is ready to accept requests. The response also contains the project version for debugging purpose.

### System health

The project exposes a `GET /health` route that contains checks to make sure the application and its external dependencies are healthy.

| Name       | Description                                |
| ---------- | ------------------------------------------ |
| `noop`     | This check is always healthy               |
| `database` | Check if the database connection is active |

## 🚀 Deploy

### Container

A Docker image can be created with `make build` and pushed to a registry with `make push`.

## License

Killswitch is © 2013-2022 [Mirego](https://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause). See the [`LICENSE.md`](https://github.com/mirego/killswitch/blob/master/LICENSE.md) file.

The shield logo is based on [this lovely icon by Kimmi Studio](https://thenounproject.com/icon/shield-1055246/), from The Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.

## About Mirego

[Mirego](https://www.mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We’re a team of [talented people](https://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://www.mirego.org).

We also [love open-source software](https://open.mirego.com) and we try to give back to the community as much as we can.
