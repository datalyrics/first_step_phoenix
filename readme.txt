postgres
=================================================================================


1. Installation & start
    > brew install postgresql@17
    > echo 'export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"' >> ~/.zshrc
    > exec zsh
    > brew services start postgresql@17
    > pg_isready
    > psql --version

2. Auth to MD5 (instead of SCRAM)
    > psql -d postgres -c "ALTER SYSTEM SET password_encryption = 'md5';"
    > brew services restart postgresql@17
    > psql -d postgres -c "SHOW password_encryption;"   # => md5

3. pg_hba.conf switch to MD5 (file: /opt/homebrew/var/postgresql@17/pg_hba.conf):
    local   all             all                                     md5
    host    all             all             127.0.0.1/32            md5
    host    all             all             ::1/128                 md5
    local   replication     all                                     md5
    host    replication     all             127.0.0.1/32            md5
    host    replication     all             ::1/128                 md5

    > brew services restart postgresql@17

4. setup app-user (temporarily set local socket to trust, then back to md5)
    # (temporary) in pg_hba.conf: first ‘local’ line -> trust, then:
    > brew services restart postgresql@17

    > psql -d postgres -c "CREATE ROLE my_app LOGIN PASSWORD 'postgres' CREATEDB;"

    # Back in pg_hba.conf: first ‘local’ line -> md5, then:
    > brew services restart postgresql@17

5. Test login & create databases
    psql -h 127.0.0.1 -U my_app -d postgres -c "SELECT current_user, current_database();"
    psql -h 127.0.0.1 -U my_app -d postgres -c "CREATE DATABASE my_app_dev OWNER my_app;"
    psql -h 127.0.0.1 -U my_app -d postgres -c "CREATE DATABASE my_app_test OWNER my_app;"
    psql -h 127.0.0.1 -U my_app -d my_app_dev -c "SELECT 'ok' AS status;"




phoenix
=================================================================================


1. Install Phoenix 1.2 Generator
    > mix archive.uninstall phoenix_new || true
    > mix local.hex --force
    > mix local.rebar --force
    > mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new-1.2.5.ez
    > mix help | grep phoenix.new

2. Create project
    /path/where/the/project/should/be/located
    mix phoenix.new my_app --database postgres
    cd my_app

3. Customize DB-Config
    - config/dev.exs:
        config :my_app, MyApp.Repo,
            adapter: Ecto.Adapters.Postgres,
            username: "my_app",
            password: "postgres",
            database: "my_app_dev",
            hostname: "127.0.0.1",
            pool_size: 10

    - config/test.exs:
        config :my_app, MyApp.Repo,
            adapter: Ecto.Adapters.Postgres,
            username: "my_app",
            password: "postgres",
            database: "my_app_test",
            hostname: "127.0.0.1",
            pool: Ecto.Adapters.SQL.Sandbox


4. Pin compatible Deps (due to Elixir 1.6.6)
    In mix.exs in defp deps:
        {:postgrex, "~> 0.13"},
        {:gettext, "== 0.11.0", override: true},

    Re-resolve/re-compile:
    > mix deps.unlock --all
    > rm -rf _build deps
    > mix deps.get
    > mix deps.compile

5. Database & Server
    > mix ecto.create
    > mix phoenix.server
    # Browser: http://localhost:4000

6. file not in the repo:
- my_app/config/prod.secret.exs
you should adjust: secret_key_base, username, password

    use Mix.Config

    # In this file, we keep production configuration that
    # you likely want to automate and keep it away from
    # your version control system.
    #
    # You should document the content of this
    # file or create a script for recreating it, since it's
    # kept out of version control and might be hard to recover
    # or recreate for your teammates (or you later on).
    config :my_app, MyApp.Endpoint,
    secret_key_base: "foobar"

    # Configure your database
    config :my_app, MyApp.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "user",
    password: "pass",
    database: "my_app_prod",
    pool_size: 20