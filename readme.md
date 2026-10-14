# 🛠 How to Build for Motorola Cancunf

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

   - **For CipherOS (Android 16 QPR2)**:
     ```bash
     crave run --no-patch -- "curl -sL https://raw.githubusercontent.com/Zoro-15/crave-scripts/main/cipher.sh | bash"
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
- **Maintainer**: Zoro-15

---

## 🤝 Credits

Big thanks to:
- [Sarthak Roy](https://t.me/sarthakroy2002)
- [cyberknight777](https://t.me/cyberknight777)
- And all Android open-source contributors ❤️
