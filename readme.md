# 📱 Custom ROM Builds for Motorola Cancunf

Welcome to the central repository for all custom ROM builds for the **Motorola Cancunf** (codename: `cancunf`). This repository includes:

- ✅ Build guides for multiple ROMs  
- 📦 Required device & vendor sources  
- 🔧 Patches, overlays, and other modifications

---

## 📂 Available ROMs

| ROM         | Android Version | Status    |
|-------------|-----------------|-----------|
| AviumUI     | Android 16 QPR2 | ✅ Stable |


> 🔔 New ROMs will be added and maintained over time. Stay tuned!

---

## 🛠 How to Build

Each ROM has a dedicated guide in their respected readme.md. Follow the instructions relevant to the ROM you want to build:

- [AviumUI Build Guide](./Avium.md)

All required patches, overlays, and cherry-picks are mentioned in each guide.

### ☁️ Building with Crave Devspaces

1. **Find available project ID for Android 16 base**:
   ```bash
   crave clone list
   ```

2. **Clone the workspace in Devspace**:
   ```bash
   crave clone create --projectID <PROJECT_ID> /crave-devspaces/avium_cancunf
   cd /crave-devspaces/avium_cancunf
   ```

3. **Execute the automated build script**:
   ```bash
   crave run --no-patch -- "curl -sL https://raw.githubusercontent.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO>/<BRANCH>/avium.sh | bash"
   ```

4. **Pull the build output**:
   ```bash
   crave pull out/target/product/cancunf/*.zip .
   ```

5. **Clean up devspace when finished**:
   ```bash
   crave clone destroy /crave-devspaces/avium_cancunf
   ```


---

## 📱 Device Info

- **Device**: Motorola G54  
- **Codename**: `cancunf`  
- **Chipset**: MediaTek Dimensity 7020  
- **Maintainer**: Ayu Kashyap

---

## 🤝 Credits

Big thanks to:
- [Sarthak Roy](https://t.me/sarthakroy2002)
- [cyberknight777](https://t.me/cyberknight777)
- [AviumUI Team](https://github.com/AviumUI/)
- And all Android open-source contributors ❤️

---

## 📜 License

This repository follows the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).  
Please respect all upstream licenses when reusing code.
