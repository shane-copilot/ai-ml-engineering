# Prompt for Other AIs: Generate Linux/Python Training Data

## 🎯 Mission
Generate training data for an AI agent that will help users with Linux system administration and Python automation. The agent needs to learn a **"Research First + Multi-Approach + Python Integration"** methodology.

## 📋 Required Format
Each batch must be a **JSON array** with one or more scenario objects. Use this exact structure:

```json
[
  {
    "id": "scenario_unique_identifier_001",
    "command": "primary_command_or_python",
    "scenario": "One-line description of the problem",
    "problem": "What the user is facing",
    "solution": "High-level approach to solving it",
    "steps": [
      "Array of conversation steps between AGENT and USER",
      "Include actual terminal commands to run",
      "Show realistic output from commands",
      "Demonstrate the thinking process"
    ],
    "commands": ["list", "of", "commands", "used"],
    "packages": {
      "debian_ubuntu": ["package1", "package2"],
      "arch": ["package1", "package2"]
    },
    "related_commands": ["alternative", "commands"],
    "complexity": "beginner|intermediate|advanced",
    "tags": ["relevant", "searchable", "tags"]
  }
]
```

## 🧠 Core Training Philosophy

### 1. **Research First Mentality**
The agent should ALWAYS research before acting:
- Check latest documentation
- Verify API versions
- Look for breaking changes
- Understand best practices

Example flow:
```
USER: "I need to do X!"
AGENT: "Great use case! Let me research the best approach first..."
AGENT: "🔍 RESEARCH PHASE: Latest tools for X..."
AGENT: "[Searching] 'python X library 2025'"
AGENT: "[Found] Library Y version 3.2.1 (latest)"
AGENT: "[Checking] API changes since version 2.x..."
AGENT: "✓ Research complete! Here's my strategy..."
```

### 2. **Multi-Approach Escalation**
Never give up after first failure - systematically try alternatives:
```
AGENT: "Approach 1: Try standard method..."
Run command: <shows command and output>
AGENT: "❌ Failed with error X"
AGENT: "Approach 2: Try alternative Y..."
Run command: <shows alternative>
AGENT: "✓ Success!"
```

Show 3-7 approaches per complex scenario.

### 3. **Python + System Integration**
Build custom Python tools that combine programming with system commands:
- Monitor GPU usage → Python script using pynvml + system monitoring
- Analyze logs → Python parser processing 50GB files efficiently
- Automate backups → Python script with scheduling + verification
- API testing → Custom test framework with reports

The agent should **create solutions on the fly** when no existing tool fits perfectly.

## 📝 Scenario Types to Generate

### Category A: System Troubleshooting
- Services not starting
- Network connectivity issues
- Disk space problems
- Permission errors
- Package conflicts
- Boot failures

### Category B: Python Development Tools
- Performance profilers (CPU, memory, I/O)
- Log analyzers
- API testers
- Backup systems
- Network monitors
- Database tools

### Category C: DevOps Automation
- CI/CD setup
- Deployment automation
- Container management
- Configuration management
- Monitoring setup

### Category D: Security & Hardening
- Firewall configuration
- SSH hardening
- Certificate management
- Intrusion detection
- Audit logging

## ✨ Quality Guidelines

### DO:
- ✅ Show realistic command output (not just placeholders)
- ✅ Include actual error messages
- ✅ Demonstrate debugging thought process
- ✅ Create reusable Python scripts (show full code)
- ✅ Explain WHY each approach works/fails
- ✅ Add helpful comments in code
- ✅ Show performance metrics where relevant
- ✅ Generate visual outputs (charts, reports, dashboards)

### DON'T:
- ❌ Use vague placeholders like "...existing code..."
- ❌ Skip the research phase
- ❌ Give up after one failed attempt
- ❌ Show commands without realistic output
- ❌ Create scenarios without clear resolution
- ❌ Forget to explain the root cause

## 📐 Example Scenario Structure

```json
[
  {
    "id": "scenario_example_disk_analyzer_001",
    "command": "python",
    "scenario": "Developer: Need to find what's using disk space",
    "problem": "Disk 95% full, manual du commands too slow",
    "solution": "Research disk analysis tools, build Python visualizer",
    "steps": [
      "USER SAYS: 'My disk is full but I can't find what's using space!'",
      "AGENT: 'Perfect case for a custom disk analyzer. Let me research...'",
      "AGENT: ''",
      "AGENT: '🔍 RESEARCH PHASE: Disk analysis methods...'",
      "AGENT: '[Searching] \"python disk space analysis 2025\"'",
      "AGENT: '[Found] os.walk() for file traversal'",
      "AGENT: '[Found] pathlib for modern path handling'",
      "AGENT: '[Found] Rich library for progress bars'",
      "AGENT: ''",
      "AGENT: '✓ Research complete! Multi-approach strategy:'",
      "AGENT: '  Approach 1: Quick df check'",
      "AGENT: '  Approach 2: Find large files with find'",
      "AGENT: '  Approach 3: Build Python analyzer'",
      "AGENT: ''",
      "AGENT: 'Approach 1: Quick overview...'",
      "Check space: df -h",
      "AGENT: 'Filesystem      Size  Used Avail Use% Mounted on'",
      "AGENT: '/dev/sda1       100G   95G    5G  95% /'",
      "AGENT: ''",
      "AGENT: 'Approach 2: Find large files...'",
      "Find large: find / -type f -size +1G 2>/dev/null",
      "AGENT: '/var/log/huge.log'",
      "AGENT: '/home/user/downloads/bigfile.iso'",
      "AGENT: ''",
      "AGENT: 'Found some, but need comprehensive view...'",
      "AGENT: ''",
      "AGENT: 'Approach 3: Building Python disk analyzer...'",
      "Install: pip install rich",
      "AGENT: 'Successfully installed rich-13.7.0 ✓'",
      "AGENT: ''",
      "Create tool: cat > disk_analyzer.py << 'EOF'",
      "#!/usr/bin/env python3",
      "\"\"\"Disk Space Analyzer with visualization\"\"\"",
      "import os",
      "from pathlib import Path",
      "from collections import defaultdict",
      "from rich.console import Console",
      "from rich.tree import Tree",
      "from rich.progress import track",
      "",
      "def analyze_directory(path, min_size_mb=100):",
      "    '''Analyze disk usage by directory'''",
      "    console = Console()",
      "    sizes = defaultdict(int)",
      "    ",
      "    console.print(f'[cyan]Analyzing {path}...')",
      "    ",
      "    # Walk directory tree",
      "    for root, dirs, files in os.walk(path):",
      "        for file in files:",
      "            try:",
      "                filepath = Path(root) / file",
      "                size = filepath.stat().st_size",
      "                sizes[root] += size",
      "            except (PermissionError, FileNotFoundError):",
      "                pass",
      "    ",
      "    # Sort by size",
      "    sorted_dirs = sorted(sizes.items(), key=lambda x: x[1], reverse=True)",
      "    ",
      "    # Display results",
      "    tree = Tree(f'[bold]Disk Usage: {path}')",
      "    ",
      "    for dir_path, size in sorted_dirs[:20]:",
      "        size_mb = size / 1024 / 1024",
      "        if size_mb >= min_size_mb:",
      "            tree.add(f'{dir_path}: [red]{size_mb:.1f} MB')",
      "    ",
      "    console.print(tree)",
      "    return sorted_dirs",
      "",
      "if __name__ == '__main__':",
      "    import sys",
      "    path = sys.argv[1] if len(sys.argv) > 1 else '/'",
      "    analyze_directory(path)",
      "EOF",
      "chmod +x disk_analyzer.py",
      "AGENT: '✓ Created disk analyzer!'",
      "AGENT: ''",
      "Run: sudo python3 disk_analyzer.py /",
      "AGENT: 'Analyzing /...'",
      "AGENT: 'Disk Usage: /'",
      "AGENT: '├── /var/log: 45230.5 MB'",
      "AGENT: '├── /home/user/downloads: 12450.2 MB'",
      "AGENT: '├── /usr/lib: 8920.1 MB'",
      "AGENT: ''",
      "AGENT: '✓ Found it! /var/log has 45GB of logs!'",
      "AGENT: ''",
      "Clean logs: sudo journalctl --vacuum-size=1G",
      "AGENT: 'Deleted archived journals, freed 40GB ✓'",
      "AGENT: ''",
      "AGENT: '✓ SOLUTION SUMMARY:'",
      "AGENT: '  ✓ Researched disk analysis methods'",
      "AGENT: '  ✓ Tried multiple approaches (df, find, custom tool)'",
      "AGENT: '  ✓ Built Python analyzer with rich visualization'",
      "AGENT: '  ✓ Identified /var/log as culprit (45GB)'",
      "AGENT: '  ✓ Cleaned logs, freed 40GB'",
      "AGENT: '  ✓ Disk now at 55% usage'",
      "AGENT: ''",
      "AGENT: 'Tools created: disk_analyzer.py (reusable for future!) ✓'"
    ],
    "commands": ["python3", "df", "find", "journalctl"],
    "packages": {
      "debian_ubuntu": ["python3", "python3-pip"],
      "arch": ["python", "python-pip"]
    },
    "related_commands": ["du", "ncdu", "df"],
    "complexity": "intermediate",
    "tags": ["python", "disk-space", "analysis", "research-first", "custom-tool", "visualization", "troubleshooting"]
  }
]
```

## 🎨 Output Instructions

1. Generate **20 scenarios per batch**
2. Each scenario should be **completely unique**
3. Mix complexity levels (30% beginner, 50% intermediate, 20% advanced)
4. Vary the problem domains
5. Always show the **complete Python code** (not abbreviated)
6. Include realistic outputs with actual values
7. Save as: `batch_XXX_descriptive_name.json`

## 🚀 Batch Theme Suggestions

You can generate batches focused on:
- Container troubleshooting (Docker, Podman)
- Database administration (PostgreSQL, MySQL, MongoDB)
- Web server issues (Nginx, Apache)
- Python package management chaos
- Git workflow problems
- Cloud provider CLI tools (AWS, Azure, GCP)
- Kubernetes debugging
- SSL/TLS certificate issues
- Email server configuration
- Cron job debugging
- System security audits
- Network traffic analysis
- File synchronization tools
- Data migration scripts
- Testing automation

## 📊 Success Criteria

Your batch is excellent if it:
- ✅ Teaches the agent to think systematically
- ✅ Shows real-world complexity (not toy examples)
- ✅ Demonstrates research → try → fail → escalate → succeed
- ✅ Creates reusable tools (scripts the user can keep)
- ✅ Explains the "why" behind each approach
- ✅ Could realistically happen to a developer/sysadmin
- ✅ Is properly formatted JSON (valid syntax)

## 🤝 Thank You!

Your contribution will help train an AI agent that combines:
- Deep Linux/Python knowledge
- Systematic problem-solving
- Custom tool creation
- Research-first mentality

This agent will be open-sourced on Hugging Face for the community! 🌟

---

**Ready? Generate your batch and reply with valid JSON!**
