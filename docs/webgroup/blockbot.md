# Blockbot

Blockbot is a Discord bot, written in Python, that is maintained by the Redbrick Webgroup. This project uses [`hikari`](https://github.com/hikari-py/hikari/), an opinionated microframework, to interface with the Discord API. [`hikari-arc`](https://github.com/hypergonial/hikari-arc) is the command handler and [`hikari-miru`](https://github.com/hypergonial/hikari-miru) is the component handler of choice.

## Resources

- [`hikari` Documentation](https://docs.hikari-py.dev/en/latest/)
- [`hikari` Examples](https://github.com/hikari-py/hikari/tree/master/examples)
- [`hikari-arc` Documentation](https://arc.hypergonial.com/)
- [`hikari-arc` Examples](https://github.com/hypergonial/hikari-arc/tree/main/examples/gateway)
- [`hikari-miru` Documentation](https://miru.hypergonial.com/)
- [`hikari-miru` Examples](https://github.com/hypergonial/hikari-miru/tree/main/examples)

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
- `utils.py`
    - Utility functions are stored here, that can be reused across the codebase.

## Installation

### Discord Developer Portal

As a prerequisite, you need to have an application registered on the Discord developer portal.

1. Create a Discord application [here](https://discord.com/developers/applications/).
2. Go to *"OAuth2 > URL Generator"* on the left sidebar, select the `bot` and `applications.commands` scopes, and then select the bot permissions you need (for development, you can select `Administrator`).
3. Go to the generated URL and invite the application to the desired server.

#### Bot Token

1. Open the application on the Discord developer portal.
2. Go to *"Bot"* on the left sidebar, click `Reset Token`.
3. Copy the newly generated token.

### Source Code

1. `git clone` and `cd` into the [blockbot repository](https://github.com/redbrick/blockbot).
2. It is generally advised to work in a Python [virtual environment](https://docs.python.org/3/library/venv.html):

    ```sh
    python3 -m venv .venv
    source .venv/bin/activate
    ```

3. Rename `.env.sample` to `.env` inside the repo folder and fill in the environment variables with your secrets. e.g.:

    ```
    TOKEN=<Discord bot token here>
    ```

4. Run `pip install -r requirements.txt` to install the required packages.
5. Start the bot by running `python3 -m src`.
