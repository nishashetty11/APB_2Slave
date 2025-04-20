# APB_2Slave


This repository contains the verification environment for the **AMBA APB (Advanced Peripheral Bus)** protocol. The APB protocol is designed for low-bandwidth, low-power peripherals like UART, Timers, GPIOs, etc.

---

## 📘 Overview

This APB design includes:

- One **APB master** controlled via external signals
- Two **APB slaves** selected using the 9th bit of `PADDR`
- Transfer only occurs when `PTRANSFER = 1`

---

## 🔁 APB Signal Summary

| Signal     | Width | Source         | Description                                                                 |
|------------|--------|----------------|-----------------------------------------------------------------------------|
| `PCLK`     | 1-bit  | Clock Source   | Clock input. All activity on rising edge.                                   |
| `PRESETn`  | 1-bit  | System Bus     | Active-low reset.                                                           |
| `PADDR`    | 9-bit  | APB Bridge     | Address bus. Slave is selected via 9th bit.                                 |
| `PWDATA`   | 8-bit  | APB Bridge     | Data to be written.                                                         |
| `PRDATA`   | 8-bit  | Slave          | Data to be read.                                                            |
| `PWRITE`   | 1-bit  | APB Bridge     | 1 = Write, 0 = Read.                                                        |
| `PSELx`    | 1-bit  | APB Bridge     | Select line for each slave.                                                |
| `PENABLE`  | 1-bit  | APB Bridge     | Indicates 2nd phase of data transfer.                                       |
| `PREADY`   | 1-bit  | Slave          | Slave ready for transfer completion.                                        |
| `PSLVERR`  | 1-bit  | Slave          | Indicates error on transfer.                                                |
| `PTRANSFER`| 1-bit  | System Bus     | High = Enable APB operation.                                                |

---


## ✅ Test Plan

[Apb Test Cases](https://docs.google.com/spreadsheets/d/1To9dF24lRDa2gGS8rfjhF0WfPLhh6V46s3G1ZIZL_Iw/edit?gid=0#gid=0)


