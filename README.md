# 🛠️ สร้าง .deb รัน Electron แบบ Fullscreen บน Debian 11

## ✅ เป้าหมาย
- ใช้ React + Electron สร้าง Desktop App
- รันแบบ **fullscreen** ทันทีหลังเปิดแอป
- สร้าง `.deb` สำหรับติดตั้งใช้งานในเครื่องลูกค้า

---

## 🧱 ขั้นตอนเริ่มต้น

### 1. ติดตั้ง Debian 11 บน VM หรือเครื่องจริง
- แนะนำใช้ [Debian Live XFCE](https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)
- หลังติดตั้งเสร็จ ให้เปิด Terminal

---

### 2. อัปเดตระบบ
```bash
sudo apt update && sudo apt upgrade -y
```

---

### 3. ติดตั้งเครื่องมือพื้นฐาน
```bash
sudo apt install -y git curl build-essential
```

---

### 4. ติดตั้ง Node.js LTS
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

---

## ⚙️ ตั้งค่าโปรเจกต์ React + Electron

### 5. สร้างโปรเจกต์ React + Vite
```bash
npx create-vite my-app --template react
cd my-app
npm install
```

---

### 6. ติดตั้ง Electron และเครื่องมือ dev
```bash
npm install --save-dev electron concurrently wait-on
```

---

### 7. สร้างโฟลเดอร์ `electron/` และไฟล์ `main.js`
```bash
mkdir electron
touch electron/main.js
```

#### `electron/main.js`
```js
const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow () {
  const win = new BrowserWindow({
    fullscreen: true,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
    }
  });

  win.loadFile(path.join(__dirname, '../dist/index.html'));
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
```

#### `electron/preload.js`
```js
// ปล่อยว่างไว้ หรือเพิ่ม contextBridge ถ้าต้องการ
```

---

### 8. ตั้งค่า `package.json`

#### ✅ เพิ่มใน `"scripts"`
```json
"scripts": {
  "dev": "concurrently \"vite\" \"wait-on http://localhost:5173 && electron . --no-sandbox\"",
  "build": "vite build",
  "start": "electron .",
  "dist": "electron-builder"
},
```

#### ✅ เพิ่ม field อื่น ๆ
```json
"main": "electron/main.js",
"type": "module",
"description": "Factory machine control panel UI",
"author": {
  "name": "Jay Kitti",
  "email": "jay@example.com"
},
"homepage": "https://example.com"
```

---

### 9. ติดตั้ง `electron-builder`
```bash
npm install --save-dev electron-builder
```

#### ✅ เพิ่ม `"build"` ใน `package.json`
```json
"build": {
  "appId": "com.yourcompany.machineui",
  "productName": "Machine UI",
  "files": [
    "dist",
    "electron",
    "package.json"
  ],
  "linux": {
    "target": ["deb"],
    "category": "Utility",
    "maintainer": "jay@example.com"
  }
}
```

---

## 📦 สร้าง .deb

### 10. Build React + Electron
```bash
npm run build        # สร้าง React build
npm run dist         # แพ็กเป็น .deb
```

> `.deb` จะถูกสร้างใน `dist/`

---

## 🧪 ติดตั้งแอป
```bash
sudo dpkg -i dist/my-app_0.0.1_amd64.deb
```

---

## 🚀 ตั้งให้เปิดเองตอนเปิดเครื่อง

### 11. สร้างไฟล์ `.desktop`
```bash
mkdir -p ~/.config/autostart
nano ~/.config/autostart/my-app.desktop
```

วางเนื้อหานี้:
```ini
[Desktop Entry]
Type=Application
Exec=/usr/bin/my-app
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Machine UI
Comment=Run Machine UI at startup
```

---

## ✅ สรุป

- หลังติดตั้ง `.deb` แล้ว คุณจะเปิดแอปผ่านเมนูได้
- แอปเปิดมาแบบ **fullscreen**
- ตั้งให้เปิดเองตอน boot ได้ผ่าน `.desktop` file
- พร้อมใช้งานในเครื่องลูกค้า Debian/Ubuntu ทันที

---

> 💬 มีปัญหาอะไรเพิ่ม เช่น fullscreen kiosk, ป้องกัน user ปิดแอป, หรือ auto update ก็ขอคำแนะนำเพิ่มเติมได้เลย!
