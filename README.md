# 🛠️ whoamio - The IO Agent Shell Tool

`whoamio` is a lightweight Unix/Linux IO monitoring tool with a quirky alien spirit. It is designed for sysadmins and curious hackers to quickly analyze IO activity, featuring fun modes and minimal dependencies.

## 🚀 Installation

```bash
curl -sSL https://azccriminal.space/tools/setup.sh | bash
````

> **Note:** Root privileges may be required. Run with `sudo` if needed.

---

## 📦 Usage

```bash
whoamio [mode] [options]
```

### 🔍 Modes

| Mode       | Description                                             |
| ---------- | ------------------------------------------------------- |
| `--files`  | Search for files containing 'io'.                       |
| `--dir`    | Search for directories containing 'io'.                 |
| `--PID`    | List running processes with 'io' in their command name. |
| `--iostat` | Show limited `/proc/[pid]/io` entries.                  |

### ⚙️ Options

| Option                | Description                                  |
| --------------------- | -------------------------------------------- |
| `--argument-find <s>` | Additional filter for name/content.          |
| `--regex`             | Use regex matching instead of glob patterns. |
| `--path <dir>`        | Set search directory (default: `/`).         |
| `--limit <n>`         | Limit the number of results (default: 30).   |
| `--summary`           | Show a summary of IO file counts.            |
| `--histogram`         | Display a fake IO histogram.                 |
| `--image-mode`        | Show fake IO device icons.                   |
| `--rouger`            | Speak like Rouger from space (fun mode).     |
| `--help`              | Show this help message.                      |

---

## 📈 Minimal Toolset for IO Testing

Use these common Unix tools for basic IO testing:

| Tool            | Description                       |
| --------------- | --------------------------------- |
| `iostat`        | Display disk IO statistics.       |
| `vmstat`        | Show memory and IO info.          |
| `iotop`         | Real-time IO usage by processes.  |
| `dd`            | Run IO benchmarking tests.        |
| `find` + `grep` | Classic tools for file searching. |

> Note: `whoamio` relies on basic Unix utilities like `find`, `/proc`, `grep`, `cat`, and `awk`. It has no external dependencies.

---

## 🔡 Searching Files Named a-z and 0-9

To search for files starting with letters a-z or digits 0-9 containing 'io' under a directory, use:

```bash
whoamio --files --argument-find "^[a-z0-9]" --regex --path /home/user
```

This searches inside `/home/user` for matching files.

---

## 👽 Rouger Mode

Make `whoamio` speak like the alien Rouger:

```bash
whoamio --iostat --rouger
```

Example output:

```
👽 Rouger: Earth IO is so... *primitive*. In my quadrant, files stream thoughts directly!
```

---

## 📜 Help

```bash
whoamio --help
```

---

## 🧠 Notes

* Built with minimalist Unix philosophy.
* Uses standard shell tools (`sh`, `find`, `grep`, `cat`, `awk`).
* Suitable for educational, testing, and entertainment purposes.
* Use cautiously on production systems.

---

## 🛰️ Developer

Created by Azccriminal Org.
Website: [https://azccriminal.space](https://azccriminal.space)

```
