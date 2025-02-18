# Maybe Finance Addon for Home Assistant

## Introduction

**Maybe Finance** is a personal finance management application that helps you track your expenses, income, and investments. This addon enables you to run Maybe Finance within Home Assistant as an addon, providing seamless integration into your smart home ecosystem.

### Features

- Track income and expenses
- Monitor investments
- Seamless integration with Home Assistant
- Self-hosted for privacy and control

See the main repository here: [Maybe Finance GitHub Repository](https://github.com/maybe-finance/maybe)

> **Note:**
> The add-on is currently not following the same version numbers as Maybe Finance itself but coming from a newer main branch.

---

## Installation Guide

Follow these steps to install and set up the Maybe Finance addon in Home Assistant:

### 1. Add the Maybe Finance Repository

Add the following repository to Home Assistant:

```
https://github.com/M123-dev/maybe_finance_hass/
```

### 2. Install PostgreSQL Addon

You need to install the PostgreSQL addon for database storage. Use the following repository:

```
https://github.com/alexbelgium/hassio-addons
```

Once installed, **set a password** for the PostgreSQL addon and start it.

### 3. Install the Maybe Finance Addon

- Go to **Add-on Store** in Home Assistant.
- Search for **Maybe Finance** and install it.

### 4. Configure the Addon

- Set a **secure secret key** (this is required for authentication security).
- Use the **same database password** as set in the PostgreSQL addon.

### 5. Start the Maybe Finance Addon

After configuration, start the addon from the Home Assistant interface.

### 6. Access Maybe Finance

Once the addon is running, you can access the Maybe Finance application at:

```
http://your-home-assistant-ip:1234
```

or

```
http://homeassistant.local:1234
```

Additionally, there is a **button in the addon interface** to open the web UI directly.

---

## Contributing

If you find any issues or want to contribute, please visit the repository:
[Maybe Finance Addon GitHub Repository](https://github.com/M123-dev/maybe_finance_hass/)

We welcome contributions in the form of bug reports, feature requests, and pull requests.

- For addon-specific issues or feature requests, please open an issue in the [Maybe Finance Addon Repository](https://github.com/M123-dev/maybe_finance_hass/).
- If you encounter bugs or have feature requests for the **Maybe Finance** application itself, please open an issue in the [Main Maybe Finance Repository](https://github.com/maybe-finance/maybe).

---

## License

This project is licensed under the **GNU AFFERO GENERAL PUBLIC LICENSE** **Version 3**

