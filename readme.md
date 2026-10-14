# 📱 Custom ROM Builds for Motorola Cancunf

Welcome to the central repository for all custom ROM builds for the **Motorola Cancunf** (codename: `cancunf`). This repository includes:

- ✅ Build guides for multiple ROMs  
- 📦 Required device & vendor sources  
- 🔧 Patches, overlays, and other modifications

---

## 📂 Available ROMs

| ROM         | Android Version | Status    | Script |
|-------------|-----------------|-----------|--------|
| AviumUI     | Android 16 QPR2 | ✅ Stable | [avium.sh](./avium.sh) |
| AxionOS     | Android 16 QPR2 (lineage-23.2) | ✅ Stable | [axion.sh](./axion.sh) |


> 🔔 New ROMs will be added and maintained over time. Stay tuned!

---

## 🛠 How to Build

### ☁️ Building with Crave Devspaces

1. **Find available project ID for Android 16 base**:
   ```bash
   crave clone list
   ```

2. **Clone the workspace in Devspace**:
   ```bash
   crave clone create --projectID <PROJECT_ID> /crave-devspaces/cancunf_build
   cd /crave-devspaces/cancunf_build
   ```

3. **Execute the automated build script**:

   - **For AviumUI (Android 16 QPR2)**:
     ```bash
     crave run --no-patch -- "curl -sL https://raw.githubusercontent.com/Zoro-15/crave-scripts/main/avium.sh | bash"
     ```

   - **For AxionOS (Android 16 QPR2)**:
     ```bash
     crave run --no-patch -- "curl -sL https://raw.githubusercontent.com/Zoro-15/crave-scripts/main/axion.sh | bash"
     ```

4. **Pull the build output**:
   ```bash
   crave pull out/target/product/cancunf/*.zip .
   ```

5. **Clean up devspace when finished**:
   ```bash
   crave clone destroy /crave-devspaces/cancunf_build
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
