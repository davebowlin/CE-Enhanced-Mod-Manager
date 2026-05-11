# Conan Exiles Enhanced (CEE) Mod Manager

CEE Mod Manager is a simple, user-friendly application designed to help you easily manage your Conan Exiles mods, profiles, and server setups. Whether you are running a local game, managing a dedicated server, or dealing with the Steam Workshop, this tool makes everything significantly easier.

## 🐳 Running In Docker

### Production
To run the manager in Docker production, use the following command:
```bash
docker-compose -f docker-compose.release.yml up --build -d
```
You can access the web interface at `http://localhost:6080`.

### Development
If you want to contribute, edit the code, or test changes, you should use the development environment instead. The development environment maps your local files directly into the container and enables **hot-reloading** (saving a `.py` file instantly restarts the app).

To run in development mode:
```bash
docker-compose up --build
```
### Features
* **Mod Load Orders**: Easily organize your active mods, import new ones, and build stable profiles.
* **Server Management**: Configure and launch your dedicated server effortlessly.
* **Cross-Platform**: Works on Windows, and natively on Linux through the included Docker setup.

#### Changes
* **Full Linux Support**: Natively discover Steam and Conan paths on Linux platforms, including standard `~/.steam` libraries.
* **Proton Integration**: Server tracking reliably detects Dedicated Server executables running via Steam's Proton compatibility layer.
* **Docker Environment**: Introduced a comprehensive web-based Docker development/deployment image.
* **Linux SteamCMD**: Properly interfaces with Linux `steamcmd.sh` for downloading and updating Workshop mods.

### 🐳 Docker & Linux Users
This repo is fully Linux compatible without any workarounds. This includes the use of SteamCMD and Proton (when installed via Steam).

---

### Original Project
This application is a customized fork built to expand and refine the features of the original tool. 
You can find the original repository here: 
[Vercadi/conan-exiles-enhanced-manager](https://github.com/Vercadi/conan-exiles-enhanced-manager)

---

### License
This project is licensed under the MIT License - see below for details.

```text
MIT License

Copyright (c) 2026 dbowlin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
