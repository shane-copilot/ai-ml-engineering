# Phase 3 Computer Use Dataset Generation

## Purpose
Custom dataset for training Linux Sidebar AI on complex, multi-step system administration and troubleshooting scenarios.

## Dataset Specifications

### Target: 15,000 examples
- Multi-distro support (Debian/Ubuntu + Arch Linux)
- Real-world problem-solving scenarios
- Complete step-by-step solutions

### Categories & Distribution

1. **Network Configuration** (3,000 examples)
   - VPN setup, bridging, tethering, routing
   - Firewall configuration
   - DNS, DHCP, network troubleshooting

2. **Performance Debugging** (2,500 examples)
   - Bandwidth analysis, process monitoring
   - Resource bottlenecks, system profiling
   - Disk I/O, memory leaks

3. **Hardware Troubleshooting** (2,000 examples)
   - Driver issues, device detection
   - Power management, thermal issues
   - Peripheral configuration

4. **Multi-Device Setups** (2,000 examples)
   - Device synchronization, file sharing
   - Bluetooth/USB/network device coordination
   - Cross-platform interoperability

5. **Security & Privacy** (2,000 examples)
   - Hidden process detection
   - Network security auditing
   - Access control, encryption

6. **System Rescue** (1,500 examples)
   - Boot repair, filesystem recovery
   - Data recovery, backup/restore
   - Emergency system access

7. **Advanced Mixed** (1,000 examples)
   - Complex multi-step scenarios
   - Combining multiple categories
   - Edge cases

8. **Distro-Specific** (1,000 examples)
   - Package management quirks
   - Init system differences
   - Configuration file locations

## Example Format

```json
{
  "id": "cat_###",
  "scenario": "Brief description of what user wants to accomplish",
  "problem": "Detailed problem statement with context",
  "solution": "High-level approach description",
  "steps": [
    "Step 1 with commands",
    "Step 2 with commands",
    "..."
  ],
  "commands": ["cmd1", "cmd2"],
  "packages": {
    "debian_ubuntu": ["pkg1", "pkg2"],
    "arch": ["pkg1-arch", "pkg2-arch"]
  },
  "complexity": "beginner|intermediate|advanced",
  "tags": ["tag1", "tag2"]
}
```

## Generation Progress

Track in `generation_progress.json` for resumability across chat sessions.

## Usage

After generation complete:
1. Combine all batches into single dataset
2. Convert to HuggingFace dataset format
3. Upload or use directly in Phase 3 training notebook
