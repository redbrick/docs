---
id: blockbot
aliases:
  - Blockbot
tags:
  - webgroup
  - discord
title: Blockbot
---

# Blockbot

Blockbot is a Discord bot, written in Python, that is maintained by the Redbrick Webgroup. This project uses [`hikari`](https://github.com/hikari-py/hikari/), an opinionated microframework, to interface with the Discord API. [`hikari-arc`](https://github.com/hypergonial/hikari-arc) is the command handler and [`hikari-miru`](https://github.com/hypergonial/hikari-miru) is the component handler of choice.

## File Structure

All bot files are under `src/`.

- `bot.py`
    - Contains the bot configuration and instantiation (e.g. loading the bot extensions).
- `extensions/`
    - Contains extensions (files) that are loaded when the bot is started. Extensions are a way to split bot logic across multiple files, commonly used to group different features. Extensions can contain plugins, command, event listeners and other logic. [Read more](https://arc.hypergonial.com/guides/plugins_extensions/).
- `examples/`
    - Contains example extensions with commands, components and more as reference for developers.
- `config.py`
    - Configuration secrets and important constants (such as identifiers) are stored here. The secrets are loaded from environment variables, so you can set them in your shell or in a `.env` file.
- `database.py`
    - Contains database configuration and models. Uses [SQLAlchemy](https://www.sqlalchemy.org/)
- `hooks.py`
    - Contains command hooks - functions which run before command invocation to determine whether or not the command should actually be run (e.g. permissions check).
- `utils.py`
    - Utility functions are stored here, that can be reused across the codebase.

## Installation

> [!TIP]
> Docker Compose for local development is highly recommended. This is similar to how it is deployed on Redbrick.

### Discord Developer Portal

As a prerequisite, you need to have an application registered on the Discord developer portal.

1. Create a Discord application [here](https://discord.com/developers/applications/).
2. Go to *"OAuth2 > URL Generator"* on the left sidebar, select the `bot` and `applications.commands` scopes, and then select the bot permissions you need (for development, you can select `Administrator`).
3. Go to the generated URL and invite the application to the desired server.

#### Bot Token

1. Open the application on the Discord developer portal.
2. Go to *"Bot"* on the left sidebar and click `Reset Token`.
3. Copy the newly generated token.

### Running from source (deprecated)

Blockbot uses [`uv`](https://docs.astral.sh/uv/) to manage dependencies and run the project.

1. Fork, `git clone` and `cd` into the [blockbot repository](https://github.com/redbrick/blockbot).

    > [!TIP]
    > Read the [contributing docs](./contributing.md) for more information on using Git and GitHub.

2. It is generally advised to work in a Python [virtual environment](https://docs.astral.sh/uv/reference/cli/#uv-venv):

    ```sh
    uv venv
    source .venv/bin/activate
    ```

3. Rename `.env.sample` to `.env` inside the repo folder and fill in the environment variables with your secrets. e.g.:

    ```
    TOKEN=<Discord bot token here>
    ```

4. Run `uv sync --frozen` to install the required packages.
5. Start the bot by running `uv run -m src`.

    > [!NOTE]
    > Currently a valid database connection is required for the bot to start. Therefore we recommend running Blockbot with docker compose (the compose file includes a PostgreSQL service).

### Running with Docker Compose

1. Fork, `git clone` and `cd` into the [blockbot repository](https://github.com/redbrick/blockbot).

    > [!TIP]
    > Read the [contributing docs](./contributing.md) for more information on using Git and GitHub.


2. Rename `.env.sample` to `.env` inside the repo folder and fill in the environment variables with your secrets. e.g.:

    ```
    TOKEN=<Discord bot token here>
    ```

3. Run the bot: `docker compose up --build bot`
    This will also start the database.

### Contributing Tools

Blockbot adheres to various code styling and typing rules (listed under `[tool.ruff.format]` and `[tool.ruff.lint]` in `pyproject.toml`).
To make sure you're following these rules when developing Blockbot, we use [`nox`](https://nox.thea.codes/en/stable/index.html).

`nox` is configured in a `noxfile.py` file, located [here](https://github.com/redbrick/blockbot/blob/main/noxfile.py) for Blockbot.

1. Install `nox`

    ```sh
    uv sync --group nox --frozen
    ```

2. Run `nox`

    ```sh
    uv run nox
    ```

    To run a specific session (e.g. `format_fix`):
    ```sh
    uv run nox -s format_fix
    ```

3. Fix any issues `nox` reports. This could be:

    * code style issues, most of which [`ruff`](https://docs.astral.sh/ruff/) (the code linter/formatter) will try to fix automatically
    * typing issues found by [`pyright`](https://github.com/microsoft/pyright). These will need to be fixed manually.
    
    Contact the webmaster if you need assistance fixing any issues!

## Library Resources
- `hikari` [Documentation](https://docs.hikari-py.dev/en/latest/) & [Examples](https://github.com/hikari-py/hikari/tree/master/examples)
- `hikari-arc` [Documentation](https://arc.hypergonial.com/) & [Examples](https://github.com/hypergonial/hikari-arc/tree/main/examples/gateway)
- `hikari-miru` [Documentation](https://miru.hypergonial.com/) & [Examples](https://github.com/hypergonial/hikari-miru/tree/main/examples)

## Usage Guides

### hikari

* [Getting Started](https://hg.cursed.solutions/#getting-started) - first steps of using `hikari`
* [Events](https://hg.cursed.solutions/01.events/) - understanding receiving events from Discord with `hikari`

### hikari-arc

* [Getting Started](https://arc.hypergonial.com/getting_started/) - first steps of using `hikari-arc`
* [Guides](https://arc.hypergonial.com/guides/) - various guides on aspects of `hikari-arc`

### hikari-miru

* [Getting Started](https://miru.hypergonial.com/getting_started/) - first steps of using `hikari-miru`
* [Guides](https://miru.hypergonial.com/guides/) - various guides on aspects of `hikari-miru`

## FAQ

### What's the difference between `hikari`, `hikari-arc` and `hikari-miru`?

* `hikari` -  the Discord API wrapper. Can be used to, for example:
    * [create threads](https://docs.hikari-py.dev/en/stable/reference/hikari/api/rest/#hikari.api.rest.RESTClient.create_thread)
    * [send individual messages](https://docs.hikari-py.dev/en/stable/reference/hikari/api/rest/#hikari.api.rest.RESTClient.create_message)
    * [fetch guild (server) information](https://docs.hikari-py.dev/en/stable/reference/hikari/api/rest/#hikari.api.rest.RESTClient.fetch_guild)
    * update member roles ([add role](https://docs.hikari-py.dev/en/stable/reference/hikari/api/rest/#hikari.api.rest.RESTClient.add_role_to_member), [remove role](https://docs.hikari-py.dev/en/stable/reference/hikari/api/rest/#hikari.api.rest.RESTClient.remove_role_from_member), [edit roles](https://docs.hikari-py.dev/en/stable/reference/hikari/api/rest/#hikari.api.rest.RESTClient.edit_member))
    * listen for events from Discord, like [message edits](https://docs.hikari-py.dev/en/stable/reference/hikari/events/message_events/#hikari.events.message_events.MessageUpdateEvent)
* `hikari-arc` - the command handler. Can be used to:
    * create application commands ([slash](https://arc.hypergonial.com/guides/options/#declaring-options), [message & user commands](https://arc.hypergonial.com/guides/context_menu/))
    * respond to command interactions
* `hikari-miru` - the component handler. Can be used to:
    * create message components (buttons, select menus & modals)
    * respond to component interactions (button clicks, select menu selections & modal submissions)

### Why use a `hikari.GatewayBot` instead of a `hikari.RESTBot`?

**TL;DR:** `RESTBot`s do not receive events required for some blockbot features (e.g. starboard), so `GatewayBot` must be used instead.

`GatewayBot`s connect to Discord via a websocket, and Discord sends events (including interactions) through this websocket. `RESTBot`s run a web server which Discord sends only interactions to (not events) via HTTP requests. These events are required for specific blockbot features, like starboard (which uses reaction create/remove events).

**Further reading:** <https://arc.hypergonial.com/getting_started/#difference-between-gatewaybot-restbot>

### What's the difference between `hikari.GatewayBot`, `arc.GatewayClient` and `miru.Client`?

* `hikari.GatewayBot` is the actual Discord bot. It:
    * manages the websocket connection to Discord
    * sends HTTP requests to the Discord REST API
    * caches information received in events sent by Discord
* `arc.GatewayClient` adds additional functionality to `hikari.GatewayBot` for:
    * splitting the bot across multiple files using [extensions](https://arc.hypergonial.com/guides/plugins_extensions/#extensions)
    * grouping commands using [plugins](https://arc.hypergonial.com/guides/plugins_extensions/#plugins)
    * easily creating and managing commands and [command groups](https://arc.hypergonial.com/guides/command_groups/)
    * accessing objects globally (in any extension, plugin or command) using [dependency injection](https://arc.hypergonial.com/guides/dependency_injection/) (e.g. a database connection)
* `miru.Client` adds additional functionality to `hikari.GatewayBot` for:
    * creating message components using [views](https://miru.hypergonial.com/getting_started/#first-steps)
    * creating [modals](https://miru.hypergonial.com/guides/modals/)
    * creating [navigators](https://miru.hypergonial.com/guides/navigators/) and [menus](https://miru.hypergonial.com/guides/menus/) using views

## Do's and Don'ts

* Always try to get data from the cache before fetching it from the API.
    
    ```py
    # command example
    async def command(ctx: arc.GatewayContext) -> None:
        user = ctx.client.cache.get_user(123)
        if not user:
            user = await ctx.client.rest.fetch_user(123)
    ```
