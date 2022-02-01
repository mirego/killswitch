<div align="center">
  <img src="https://user-images.githubusercontent.com/11348/151395659-3ebe29b6-b1d6-44fa-bb44-c42146c7e99a.png" width="563" />
  <p><strong>Killswitch</strong> is a clever control panel built by <a href="https://www.mirego.com">Mirego</a> that allows mobile developers to apply<br /> runtime version-specific behaviors to their iOS or Android application.</p>
  <a href="https://github.com/mirego/killswitch/actions/workflows/ci.yaml"><img src="https://github.com/mirego/killswitch/actions/workflows/ci.yaml/badge.svg" /></a><br /><br />
</div>

| Section                                 | Description                                            |
| --------------------------------------- | ------------------------------------------------------ |
| [🚧 Dependencies](#-dependencies)       | Technical dependencies and how to install them         |
| [🏎 Kickstart](#-kickstart)              | Details on how to kickstart development on the project |
| [🏇 Usage](#-usage)                     | Details on how to use the application                  |
| [🚑 Troubleshooting](#-troubleshooting) | Recurring problems and proven solutions                |
| [🚀 Deploy](#-deploy)                   | Deployment instructions                                |

## 🚧 Dependencies

Every runtime dependencies are defined in the `.tool-versions` file. These external dependencies are also required:

- PostgreSQL (`~> 10.0`)

## 🏎 Kickstart

### Environment variables

All required environment variables are documented in [`.env.dev`](./.env.dev).

When running `rails`, `rake` or `make` commands, it is important that these variables are present in the environment. There are several ways to achieve this. Using [`nv`](https://github.com/jcouture/nv) is recommended since it works out of the box with `.env.*` files.

### Initial setup

1. Create both `.env.dev.local` and `.env.test.local` from empty values in [`.env.dev`](./.env.dev) and [`.env.test`](./.env.test)
2. Install Ruby and NPM dependencies with `make dependencies`
3. Generate values for mandatory secrets in [`.env.dev`](./.env.dev) with `rake secret`

Then, with variables from `.env.dev` and `.env.dev.local` present in the environment:

4. Create and migrate the database with `rake db:setup`
5. Start the Rails server with `rails s`

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

## 🏇 Usage

### HTTP requests

#### Request a behavior

```
GET /killswitch
```

##### Parameters

| Field     | Type   | Description                                                                                  |
| --------- | ------ | -------------------------------------------------------------------------------------------- |
| `key`     | String | The API key (eg. `"f206934e29160b43924308251b88"`)                                           |
| `version` | String | The version of the application to test against (see _Conventions → Version numbers_ section) |

##### Headers

| Header            | Description                                                                                                |
| ----------------- | ---------------------------------------------------------------------------------------------------------- |
| `Accept-Language` | The application language (the API will return localized messages, if available (eg. `Accept-Language: fr`) |

##### Possible erroneous responses

| Status | Code        | Reason                                                |
| ------ | ----------- | ----------------------------------------------------- |
| `400`  | Bad Request | Parameters are malformed or missing                   |
| `404`  | Not Found   | The API key is not for a valid project or application |

##### Possible successful responses

| Status | Code         | Message                                                                                                         |
| ------ | ------------ | --------------------------------------------------------------------------------------------------------------- |
| `200`  | OK           | Everything is under control, yay                                                                                |
| `304`  | Not Modified | If an `If-None-Match` header is passed and a cached response exist, a `304` will be returned with an empty body |

### Conventions

#### Version numbers

Version numbers supported by Killswitch must match the following regular expression:

```
/^\d+(\.\d+)?(\.\d+)?(\.\w+)?$/
```

Here are some valid and invalid version number examples:

| Version number | Valid              |
| -------------- | ------------------ |
| `1`            | :white_check_mark: |
| `1.2`          | :white_check_mark: |
| `1.2.3`        | :white_check_mark: |
| `1.2.3.4`      | :white_check_mark: |
| `1.2.3.foo`    | :white_check_mark: |
| `foo`          | :x:                |
| `1.`           | :x:                |
| `1.2.`         | :x:                |
| `1.2.3.4.5`    | :x:                |

### Behaviors JSON representations

#### Root element

| Key       | Type   | Description                                                               |
| --------- | ------ | ------------------------------------------------------------------------- |
| `action`  | String | The action the application should enforce (`"ok"`, `"alert"` or `"kill"`) |
| `message` | String | A message to display to the user                                          |
| `buttons` | Array  | An array of buttons to show to the user                                   |

##### Buttons

| Key     | Type   | Description                                                                                    |
| ------- | ------ | ---------------------------------------------------------------------------------------------- |
| `type`  | String | The type of button (`"cancel`, `"url"` or `"reload"`), defaults to `"cancel"` if not specified |
| `label` | String | The button label                                                                               |
| `url`   | String | The button URL, if the type is `"url"`                                                         |

#### Examples

##### OK

```json
{
  "action": "ok",
  "buttons": []
}
```

##### Alert

```json
{
  "action": "alert",
  "message": "SUP?",
  "buttons": [
    {
      "type": "cancel",
      "label": "Nothing"
    }
  ]
}
```

##### Kill

```json
{
  "action": "kill",
  "message": "The app will be killed now. Please upgrade to the latest version.",
  "buttons": [
    {
      "type": "url",
      "label": "Upgrade",
      "url": "itms://foo"
    },
    {
      "type": "cancel",
      "label": "I don’t want to."
    }
  ]
}
```

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
