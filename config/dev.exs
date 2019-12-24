use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :hive_backend, HiveBackendWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :hive_backend, HiveBackendWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/hive_backend_web/{live,views}/.*(ex)$",
      ~r"lib/hive_backend_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure your database
config :hive_backend, HiveBackend.Repo,
  username: "postgres",
  password: "postgres",
  database: "hive_backend_dev",
  hostname: "localhost",
  pool_size: 10


config :riemannx, [
  host: "localhost", # The riemann server
  event_host: "hive_mind_backend", # You can override the host name sent to riemann if you want (see: Host Injection)
  send_timeout: 30_000, # Synchronous send timeout
  checkout_timeout: 30_000, # Timeout for checking out a poolboy worker
  type: :batch, # The type of connection you want to run (:tcp, :udp, :tls, :combined, :batch)
  settings_module: Riemannx.Settings.Default, # The backend used for reading settings back
  metrics_module: Riemannx.Metrics.Default, # The backend used for sending metrics
  use_micro: true, # Set to false if you use a riemann version before 0.2.13
  batch_settings: [
    type: :combined, # The underlying connection to use when using batching.
    size: 50, # The size of batches to send to riemann.
    interval: {1, :seconds} # The interval at which to send batches.
  ],
  tcp: [
    port: 5555,
    retry_count: 5, # How many times to re-attempt a TCP connection
    retry_interval: 1000, # Interval to wait before the next TCP connection attempt (milliseconds).
    priority: :high, # Priority to give TCP workers.
    options: [], # Specify additional options to be passed to gen_tcp (NOTE: [:binary, nodelay: true, packet: 4, active: true] will be added to whatever you type here as they are deemed essential)
    pool_size: 5, # How many TCP workers should be in the pool.
    max_overflow: 5, # Under heavy load how many more TCP workers can be created to meet demand?
    strategy: :fifo # The poolboy strategy for retrieving workers from the queue
  ]
]