 # Zikuani

## Overview

Zikuani is a privacy preserving wallet that allows users to prove their identity in a private way. 
It provides a set of tools to generate and verify proofs, authenticate users and verify proofs off/on-chain.

The project aims to develop a zero-knowledge proof infrastructure solution for enhancing
digital identity systems. Our goal is to strengthen citizen privacy by minimizing
data collection, enabling individuals to access a wide range of valuable services without
disclosing sensitive information.

See the [documentation](https://docs.sakundi.io/) for more details.

## Rationale

Our project aims to address the privacy issues in identity systems by developing a zero-knowledge proof infrastructure using blockchain technology and ZK circuits. This solution enables citizens to verify their identity and provide specific information without revealing actual personal details. By minimizing the distribution of sensitive data across various institutions and companies, we can significantly reduce the risk of data theft. Additionally, this system can authenticate users for diverse services, ensuring they are real individuals and not bots, without requiring sensitive information such as email addresses or phone numbers.

## Potential use cases

* Anonymous authentication
* Descentralized anonymous voting
* Anonymous proof of humanity
* Health data privacy
* Know Your Customer
* Privacy-Preserving Verification
* Anti-Sybil Mechanisms
* DAO Governance
* Quadratic Funding (QF)
* Wallet Recovery
* And many more!


## Hardware Requirements
To run Zikuani, ensure your system meets at least the following hardware requirements:

| **Component** | **Specification**          |
|---------------|-----------------------------|
| CPU           | 2 Cores + 2 Threads per Core |
| RAM           | 16 GB                        |

## Installation

### Windows

1. Download the installer:
[Windows Installer](https://app.sakundi.io:9090/zikuani-0.8.1.exe)

2. Verify the sha256 hash:
    ```bash
    certutil -hashfile "C:\file\path\zikuani-0.8.1.exe" SHA256
    ```
    The result should match:
    ```bash
    20feed43e22531a87e06cfbc35cbb69b346a251ed1c2c8127e260b29577f68f1  zikuani-0.8.1.exe
    ```
3. Run the installer if the hash matches.

    Note: The Windows installer includes a couple of Javascript dependencies, Nodejs and Snarkjs. The installer also includes the zkey necessary for generating valid ZK proofs, which makes it a bit heavy.

4. Launch the program: 
    * Insert your smart card into a USB port.
    * Run: 
        ```bash
        "C:\Program Files\zk-firma-digital\zk-firma-digital.exe"
        ```
    * Alternatively, search for zk-firma-digital in the Start menu.

### Linux (Debian)

1. Download the installer:
    ```bash
    wget https://app.sakundi.io:9090/zikuani_0.8.1_amd64.deb
    ```
2. Verify the sha256 hash:
    ```bash
    sha256sum zikuani_0.8.1_amd64.deb
    ```
    The result should match:
    ```bash
    b02232886d0d130ff19d82f2bc6e58471f412a30671cacd28663f1f25c3e9217  zikuani_0.8.1_amd64.deb
    ```
3. Install the Debian package:
    ```bash
    sudo dpkg -i zikuani_0.8.1_amd64.deb
    ```
4. Launch the program:
    * Insert your smart card into a USB port.
    * Run: 
        ```bash
        /usr/share/zk-firma-digital/zk-firma-digital.bin
        ```
    * Alternatively, search for the app in your application launcher.
  
### MacOS

1. Download the installer:
[MacOs Installer](https://app.sakundi.io:9090/zikuani-0.8.1.pkg)

2. Verify the sha256 hash:
    ```bash
    sha256sum zikuani-0.8.1.pkg
    ```
    The result should match:
    ```bash
    d35bf1dc5a176adcfb521a2ff6007a83a4908ae76a55c59b3ae279f41232962b  zikuani-0.8.1.pkg
    ```
3. Run the installer if the hash matches.

    Note: The MacOS installer includes a couple of Javascript dependencies, Nodejs and Snarkjs. The installer also includes the zkey necessary for generating valid ZK proofs, which makes it a bit heavy.

4. Launch the program: 
    * Insert your smart card into a USB port.
    * Run: 
        ```bash
        "open /Applications/zk-firma-digital/Contents/MacOS/zk-firma-digital"
        ```
    * Alternatively, search for zk-firma-digital in the Finder menu.

## Build

### Linux

1. Clone the repository:
    ```bash
    git clone https://github.com/kuronosec/Zikuani
    cd Zikuani
    ```
2. Run the build script:
    ```bash
    ./builder/build_linux.sh
    ```

### Windows

1. Install the prerequisites:
    * [Git for Windows](https://gitforwindows.org/)
    * [Python 3.10+](https://www.python.org/downloads/)
    * Install PyInstaller:
        ```bash
        pip install pyinstaller
        ```
    * [Inno Setup](https://jrsoftware.org/)
    * Configure antivirus to exclude the build and release directories.

2. Clone the Repository:
    ```bash
    git clone https://github.com/kuronosec/Zikuani.git
    cd Zikuani
    ```
3. Run the build script:
    ```bash
    ./builder/build_windows.sh
    ```
4. Locate the output files:
    * Executable: `build` directory.
    * Installer: `release` directory.
5. Troubleshooting:
    * Antivirus or Security Issues: During the build process, your antivirus software (including Windows Defender) may flag the generated `.exe` file as a potential threat. This is a common issue with self-built executables. To resolve it:
        1. Add Exclusions: Configure your antivirus or security software to exclude the build and release directories.
            * For Windows Defender:
                1. Open **Windows Security**.
                2. Navigate to **Virus & threat protection**.
                3. Click on **Manage settings** under **Virus & threat protection settings**.
                4. Toggle **Real Time Protection** off temporarily (if necessary).
                5. Scroll down to **Exclusions** and click on **Add or remove exclusions**.
                6. Add the paths for both the `build` and `release` directories to the exclusion list.
        2. Validate the Executable: After adding exclusions, rerun the build process and verify that the executable runs without being flagged.
    * Missing Tools or Command Errors: If you encounter errors like `command not found` when running the build script, it may indicate missing tools or misconfigured system paths. Follow these steps:
        1. Review the build script for errors or missing dependencies.
        2. Consult the repository's issues page or documentation for additional support.

## See it working
To try the system with a decentralized voting system go to:

* Website: [https://voto.sakundi.io/vote](https://voto.sakundi.io/vote)

Other useful links:

* PoC source code: [GitHub Repository](https://github.com/kuronosec/zk-voto-digital)
* Example credential: [residence-credential.json](https://github.com/kuronosec/Zikuani/blob/main/src/examples/residence-credential.json)
