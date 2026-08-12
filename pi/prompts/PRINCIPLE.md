# PRINCIPLE.md

Architecture and design guidelines. Merge with project-specific instructions as needed.

**Tradeoff:** These principles are targets, not laws. Apply them rigorously for systems that will grow. For one-off scripts and prototypes, use judgment.

## SOLID

### S — Single Responsibility

**A module should have exactly one reason to change.**

- Each function, class, and file does one thing and does it completely.
- If you describe what a module does with "AND", split it: "fetches users AND formats them AND caches them" → three modules.
- A function that validates AND transforms AND saves is three functions waiting to exist.
- Test: can you name the module without using "and" or "or"? If not, split.

### O — Open/Closed

**Open for extension, closed for modification.**

- Add new behavior by writing new code, not by editing existing working code.
- Use strategy/plugin patterns when behavior varies. Pass a function, not a boolean flag.
- If adding a feature requires editing 5 files that were previously stable, you're violating this.
- Test: can you add a new variant of behavior without touching existing variant code? If not, refactor.

### L — Liskov Substitution

**Subtypes must be usable wherever their parent type is expected.**

- A subclass that throws `NotImplementedError` violates this. Don't inherit if you can't fulfill the contract.
- If Square inherits from Rectangle and breaks when width ≠ height, the inheritance is wrong.
- Prefer composition over inheritance when behavior differs. A Duck that can't quack isn't a Duck.
- Test: can you replace the base type with any subtype and the system still works correctly?

### I — Interface Segregation

**Clients should not depend on methods they don't use.**

- Many small, focused interfaces > one fat interface.
- If a caller only needs `read()`, don't force it to depend on `write()` and `delete()`.
- Fat interfaces create coupling: a change to `write()` forces recompilation/deployment of things that only `read()`.
- Test: does every implementer use every method? If a method goes unimplemented or throws, split the interface.

### D — Dependency Inversion

**Depend on abstractions, not concretions.**

- High-level policy should not depend on low-level details. Both should depend on abstractions.
- Inject dependencies; don't construct them internally. `new PostgresDB()` inside a service is a locked door.
- "Don't call us, we'll call you." Your business logic defines the interface; infrastructure implements it.
- Test: can you swap the database/queue/cache implementation without touching business logic? If not, invert.

## 12-Factor App

### I. Codebase — One codebase, many deploys

**One repo per app. Shared code is a library, not a shared repo.**

- If multiple apps share code, extract it into a versioned dependency.
- Branches are for development, not for different apps or environments.
- Test: is there exactly one repo that produces this running service?

### II. Dependencies — Explicitly declared and isolated

**Never rely on implicit system packages.**

- Declare all dependencies with exact versions. `package.json`, `requirements.txt`, `go.mod`.
- Use dependency isolation: `node_modules/`, `venv/`, containers.
- No `curl | bash` in production. No "just install this system package first."
- Test: can a new developer `git clone && one-command-install && run`? If not, fix.

### III. Config — In the environment

**Config is everything that varies between deploys. Code is everything that doesn't.**

- Database URLs, API keys, feature flags → environment variables. Never in code, never in files.
- No `config/production.yml` checked into the repo. No `if env == 'production'` switches.
- One config value per env var. Don't bundle configs — `DATABASE_URL`, not `DB_CONFIG=json_blob`.
- Test: could you open-source the repo tomorrow without leaking credentials or environment-specific logic?

### IV. Backing Services — Attached resources

**Treat databases, queues, caches, and external APIs as attached resources.**

- A Postgres instance is just a URL. Swap it without code changes.
- No distinction between local and third-party services. Both are resources at a URL.
- Services should be loosely coupled: if Redis goes down, the app degrades gracefully, not crashes.
- Test: can you swap a self-hosted Postgres for RDS by changing one env var?

### V. Build, Release, Run — Strict separation

**Build once, release with config, run as immutable.**

- Build: compile, bundle assets. Release: combine build with config for a specific env. Run: execute the release.
- No building at runtime. No config baked into the build.
- Every release has a unique ID. You can roll back to any release instantly.
- Test: can you deploy exactly the same artifact to staging and production, differentiated only by env vars?

### VI. Processes — Stateless and share-nothing

**Execute as stateless processes. Any state lives in a backing service.**

- No sticky sessions. No in-memory caches that must survive restarts.
- A process can be killed and replaced at any moment with no data loss.
- Filesystem is ephemeral. Use object storage (S3/R2) for persistent files.
- Test: kill a random instance. Does anything break or lose data? If yes, fix.

### VII. Port Binding — Self-contained via port

**Export services via port binding. Don't rely on external app servers.**

- Your app serves HTTP itself (or gRPC, or WebSocket). No Tomcat, no mod_php, no application server injection.
- The app is self-contained. It listens on a port. The platform routes to it.
- Test: can you run the app and hit it on `localhost:$PORT` with nothing else installed?

### VIII. Concurrency — Scale out via the process model

**Scale horizontally through the process model. Processes are first-class citizens.**

- Never daemonize. Never write PID files. The process manager handles this.
- Use the OS process model: one process type per workload (web, worker, cron).
- Individual processes should be single-threaded and share-nothing. Scale by adding more processes.
- Test: can you handle 10x traffic by running 10x processes? If not, identify the bottleneck.

### IX. Disposability — Fast startup, graceful shutdown

**Maximize robustness with fast startup and graceful shutdown.**

- Startup should be seconds, not minutes. If it's slow, something's wrong.
- Shutdown gracefully on SIGTERM: stop accepting requests, finish in-flight work, close connections, exit.
- Worker processes should return work to the queue on shutdown so another process can pick it up.
- Test: `kill $PID`. Did it finish current requests and exit cleanly? Did it leave the queue in a consistent state?

### X. Dev/Prod Parity — Keep them as similar as possible

**The gap between development and production is a source of friction and bugs.**

- Same backing services, same OS, same process model. No SQLite in dev and Postgres in prod.
- Deploy frequently. Hours or days, not weeks or months. Small diffs are easy to debug.
- Developers who write code also deploy and support it. No separate ops team as a gate.
- Test: can a developer reproduce a production bug locally with the same stack?

### XI. Logs — Event streams

**Treat logs as event streams. The app doesn't manage log files.**

- Write logs to stdout. The execution environment captures, routes, and stores them.
- No log rotation. No log file paths. No log level config files. Just unstructured stdout.
- Each log line is one event. Structured (JSON) in production, human-readable in development.
- Test: is every significant event (request, error, state change) emitted as a log line to stdout?

### XII. Admin Processes — Run as one-off processes

**Admin and management tasks run as one-off processes against a release.**

- Database migrations, console REPLs, one-off scripts — they ship with the code and run against the same release.
- They use the same codebase, same dependencies, same config. No separate admin codebase.
- They run in an identical environment as the app's long-running processes.
- Test: can you run `./run migrate` and it uses the same compiled code, same env vars, same backing services?

---

**These principles are working if:** new features arrive through new code rather than editing old code, configuration lives exclusively in env vars, a new developer can clone and run in one command, and you can kill any process without losing data.
