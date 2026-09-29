<p align="center">
  <img src="ImmichDrive/Resources/ImmichDrive.png" alt="ImmichDrive" width="128">
</p>

<h1 align="center">ImmichDrive</h1>

<p align="center">
  Your <a href="https://immich.app">Immich</a> photo library as a native cloud drive in File Explorer — on demand, without storing the photos on your PC.
</p>

<p align="center">
  <img src="docs/explorer-thumbnails.png" alt="Real thumbnails on demand inside a month folder" width="760">
</p>

<p align="center">
  <img src="docs/explorer-library.png" alt="The library in File Explorer — by date, plus Albums, Favorites, Partners and Upload" width="760">
</p>

<p align="center">
  <img src="docs/home.png" alt="ImmichDrive: connected and online" width="380">
  &nbsp;&nbsp;
  <img src="docs/tray-flyout.png" alt="System-tray flyout" width="380">
</p>

## About this fork

This is a fork of [RyanEwen/ImmichDrive](https://github.com/RyanEwen/ImmichDrive). The upstream
project is distributed only through the Microsoft Store (as a paid app), and its GitHub releases
deliberately carry no installable files. This fork exists for one reason: to publish a
**ready-to-install** on the [Releases](https://github.com/Nathan-Wrpt/ImmichDrive/releases)
page, so you can install ImmichDrive without going through the Microsoft Store and without
setting up a build environment (.NET SDK, Windows SDK tools, signing certificate).

The code changes from upstream are small: the "Our other apps" page is removed, the About page
links to this fork, and **Check for updates** looks at this fork's GitHub releases instead of the
Microsoft Store. Packages are built with the repository's own `build-msix.ps1` and signed with a self-signed certificate, so installing one
means trusting that certificate on your PC. If you'd rather not, or want to support the
original author, buy it from the [Microsoft Store](https://apps.microsoft.com/detail/9MWC6165N7DH)
instead. Redistribution here is noncommercial, as the [license](LICENSE.md) requires; these
builds are free.

### Installing from this fork

1. Download `Install.ps1`, `ImmichDrive.cer`, and the `.msix` for your PC (`x64` for most PCs,
   `ARM64` for Snapdragon/ARM devices) from the latest
   [release](https://github.com/Nathan-Wrpt/ImmichDrive/releases) into one folder.
2. Right-click `Install.ps1` → **Run with PowerShell**. Accept the admin prompt. It is needed once,
   to trust the signing certificate. Or from a PowerShell prompt in that folder:
   `powershell -ExecutionPolicy Bypass -File .\Install.ps1`
3. Open **ImmichDrive** from the Start menu and continue with [Setup](#setup-minimal) step 2.

Take a photo on your phone, let it auto-sync to Immich, and then grab it straight from your
computer's file picker — no need to open the Immich web UI, download anything by hand, or
fill up your disk. When you actually open or attach a photo, ImmichDrive fetches just that
file on demand and hands it to whatever app asked for it (great for attaching a recent photo
to a Craigslist listing, an email, or a form).

## How it works

ImmichDrive uses the same Windows mechanism as OneDrive and Dropbox, the **Cloud Files API**,
to create *placeholder* files. They look and behave like normal files in Explorer (correct
names, dates, and **thumbnails**) but take up **0 bytes** until you open one. Opening a file
("hydrating" it) streams the original down from your Immich server in the background; closing
and freeing space dehydrates it back to a placeholder.

- **Organized the way you think about it** — `2026-06 June` date folders (newest first), plus
  **Albums**, **Favorites**, and **Partners** folders that mirror Immich and stay in sync.
- **Real thumbnails without downloading** — a lightweight shell extension fetches Immich's
  small thumbnails so you can *see* your photos before opening them, with nothing on disk.
- **Lives in the tray** — a single tray icon shows status (online / syncing) and lets you
  open settings, refresh, or pause. No heavyweight background service.
- **Quiet when your server isn't there** — if Immich can't be reached (it's down, you're off
  the VPN, the laptop woke up early) the tray icon goes grey with an amber dot and the flyout
  says so. It keeps retrying on its own and reconnects when the server comes back, or you can
  hit **Try again**. No pop-ups, no sounds.

## Setup (minimal)

1. Install **ImmichDrive** from this fork's [releases](#installing-from-this-fork).
2. Open **ImmichDrive** and enter:
   - your **Immich server URL** (e.g. `https://photos.example.com`)
   - an **API key** (Immich → *Account Settings → API Keys → New API Key*).
3. Click **Test connection**, then **Connect**. Your drive appears in Explorer under
   *ImmichDrive* (a sync-root entry in the navigation pane, like OneDrive).

That's it — browse by date and double-click (or attach) any photo.

## Requirements

- **Windows 11** (build 22621 or newer): ImmichDrive relies on the Cloud Files API and modern shell thumbnails.
- **An Immich server** you can reach (any reasonably recent version), and an **API key** from it.

## Development

Building from source, the MSIX packaging pipeline, and how the pieces fit together — the resident
app, the thumbnail shell extension, the Cloud Files provider, and the on-disk index — are
documented in **[DEVELOPMENT.md](DEVELOPMENT.md)**.

ImmichDrive registers its Cloud Files sync root and its thumbnail handler from the package
manifest, so it needs package identity (MSIX) to work at all and an unpackaged build is not a
usable app. That is why this fork's releases ship signed MSIX packages rather than a loose exe.
If you want to build your own copy from source, follow the steps in DEVELOPMENT.md.

## License

Licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE.md): free for any
**personal and other noncommercial use**, including modifying and redistributing it.
**Commercial use is not permitted.** Copyright © 2026 Ryan Ewen.
