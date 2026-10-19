# No-Sleep Toggle for KDE Plasma 6

A lightweight system tray applet for **KDE Plasma 6 (Wayland & X11)** that inhibits automatic system sleep (`suspend` / `hibernate`) using native `kde-inhibit --power` managed via `systemd --user`, while allowing the display to turn off normally according to your standard DPMS / power management timeout.

## Why?

The built-in KDE **Power and Battery** applet's manual inhibition toggle blocks **both** system sleep (`sleep`) and screen blanking (`idle`). When running long background workloads (such as virtual machines, compilations, or downloads), you often want to prevent the PC from going to sleep while still allowing the monitor to turn off automatically.

This applet uses `kde-inhibit --power` to block **only** system sleep, leaving screen blanking (DPMS) and lock screen timers intact.

## Features

* **Native System Tray Integration:** Lives directly inside the KDE Plasma 6 System Tray using native Breeze inhibition icons (`system-suspend-inhibited` / `system-suspend-uninhibited`).
* **Unobtrusive Visual State:** Dimmed icon when sleep is allowed (`Auto`); full brightness with a red slash when sleep is locked.
* **Screen-Friendly Inhibition:** Blocks system sleep while keeping normal screen turn-off timeouts working.
* **One-Click Toggle:** Left-click the tray icon to toggle sleep inhibition on or off.
* **Clean Process Management:** Uses a transient `systemd-run --user` service (`kde-nosleep-toggle.service`) — no PID files or orphaned background processes.

## Requirements

* **KDE Plasma 6.0+**
* **`kde-cli-tools`** (provides `kde-inhibit`, pre-installed on KDE distributions such as Tuxedo OS, Kubuntu, KDE neon, Fedora KDE, openSUSE, Arch Linux)
* **`systemd`** (user session)

## Installation

1. Clone this repository:
   ```bash
   git clone [https://github.com/YOUR_USERNAME/plasma-applet-nosleep-toggle.git](https://github.com/YOUR_USERNAME/plasma-applet-nosleep-toggle.git)
   cd plasma-applet-nosleep-toggle
   ```
2. Run the installation script:
   ```bash
   chmod +x install.sh uninstall.sh
   ./install.sh
   ```
3. To keep the icon always visible in the tray: right-click the **System Tray** arrow → **Configure System Tray... → Entries**, find **No-Sleep Toggle**, and set it to **Always shown**.

## Uninstallation

Run the included uninstall script:
```bash
./uninstall.sh
```

## Building a `.plasmoid` Package (for KDE Store / GitHub Releases)

To package the applet into a distributable `.plasmoid` archive:
```bash
zip -r nosleep-toggle-v1.0.0.plasmoid metadata.json contents/ LICENSE README.md
```

## License

This project is licensed under the **GNU General Public License v3.0 or later** (`GPL-3.0-or-later`) — see the [LICENSE](LICENSE) file for details.
