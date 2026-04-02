# MiniRoute Verification

## 1. Project Overview

MiniRoute is a 4-port router/switch design that accepts 64-bit packets on its input ports and forwards them to the appropriate output ports based on packet type, source address, destination address, and configuration state.

This repository contains the verification environment of the MiniRoute design together with the DUT RTL. This verification environment verifies:

- reset behavior across the four ports environment
- valid broadcast, multicast, and one-to-one routing
- configuration request and configuration confirmation handling
- random traffic generation across multiple ports in parallel
- invalid source, destination, checksum, and configuration scenarios

## MiniRoute Ports

MiniRoute exposes four identical ports: `port_0`, `port_1`, `port_2`, and `port_3`. Each port accepts serialized 8-bit input data bytes from the testbench and produces serialized 8-bit output data bytes from the DUT. The verification environment builds a dedicated UVM agent for each port so traffic can be generated and monitored independently or in parallel.

## Packet Types

The current verification environment exercises these packet classes:

- `F1`: broadcast packets
- `F2`: multicast packets
- `F3`: one-to-one packets
- `F4`: configuration request packets
- `F5`: configuration packets
- `F6`: configuration response packets
- `F7`: configuration confirmation packets
- `F8`: error packets

Each packet is modeled as 8 bytes:

- `src`
- `dst`
- `checksum`
- `p_type`
- `data0`
- `data1`
- `data2`
- `data3`

## Default Addressing and Configuration

At reset, the scoreboard and tests assume the following default logical addresses:

- `port_0 = 8'hFA`
- `port_1 = 8'hFB`
- `port_2 = 8'hFC`
- `port_3 = 8'hFD`

The verification environment also tracks per port configuration state for:

- device connection enable
- broadcast enable
- configured logical address

Configuration traffic is sent first as a request packet (`F4`) and then as a configuration packet (`F5`). The scoreboard expects the DUT to return response/confirmation packets and updates its internal port state model accordingly.

## 3. Verification Architecture

The architecture diagram and additional project details are available in:

- `docs/miniroute_presentation.pdf`

Key Components

- Port Agents: one UVM agent per DUT port for stimulus generation and monitoring
- Reset Agent: drives and monitors the DUT reset signal
- Drivers: serialize 64-bit packet transactions into 8-bit input port transfers
- Sequencers: provide packet and reset transactions to the drivers
- Monitors: reconstruct packets entering or leaving the DUT on each port
- Scoreboard: predicts routing behavior, compares DUT outputs, and tracks pass/fail counters
- Environment: instantiates four data port agents, one reset agent, and the shared scoreboard

## 4. MiniRoute Interface Signals

The signal list below summarizes the main interface signals relevant to this repository.

| Signal | Direction | Description |
| --- | --- | --- |
| `clk` | Input | Main simulation clock |
| `reset` | Input | Active low reset stimulus driven through `reset_intf` |
| `port_in_x_valid` | Input | Indicates that the current input byte is valid |
| `port_in_x_data[7:0]` | Input | Serialized input packet byte stream for a given port |
| `port_in_x_success` | Output | Indicates that the DUT accepted the full input packet |
| `port_in_x_busy` | Output | Backpressure/busy indication for the corresponding input port |
| `port_out_x_valid` | Output | Indicates that an output byte is valid on the corresponding port |
| `port_out_x_data[7:0]` | Output | Serialized output packet byte stream for a given port |

## 5. Test Suite

The repository contains the following tests:

| Test Name | Description |
| --- | --- |
| `sanity_test` | Runs baseline reset, configuration, and repeated valid traffic across all four ports with one-to-one, multicast, and broadcast packet activity. |
| `configuration_test` | Stresses configuration request/configuration packet handling with randomized traffic mixes and repeated address/configuration updates. |
| `random_reset_test` | Inserts randomized resets between traffic phases and checks that the environment returns to the expected default addressing state. |
| `random_pkt_test` | Mixes valid traffic with randomized invalid request, configuration, and payload packets to exercise DUT error handling and scoreboard checks. |

## 6. How to Run

- Open ModelSim/QuestaSim
- `cd sim`
- `do run.do`

The default test in `run.do` is `sanity_test`. To run a different test, change the `+UVM_TESTNAME=` argument in `run.do` file.
