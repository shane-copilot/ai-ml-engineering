# KAGGLE NOTEBOOK TEMPLATE RULES

**CRITICAL: Follow this EXACTLY for all future Kaggle notebooks!**

---

## ✅ WORKING TEMPLATE

**Source:** `NOTEBOOK_TEMPLATE.ipynb` (copied from successful TPU test v2)

**This template has the correct structure that Kaggle accepts.**

---

## 📋 MANDATORY RULES FOR ALL NOTEBOOKS

### 1. File Format
- **MUST use VSCode.Cell XML format** (not raw JSON)
- Each cell needs `id` attribute with format: `id="#VSC-xxxxxxxx"`
- Each cell needs `language` attribute: `markdown` or `python`

### 2. Cell Structure
```xml
<VSCode.Cell id="#VSC-140f876b" language="markdown">
# Title Here
Content here
</VSCode.Cell>
<VSCode.Cell id="#VSC-3b0ecd02" language="python">
# Python code here
import torch
</VSCode.Cell>
```

### 3. Required Cell IDs (use these patterns)
- `#VSC-140f876b` - Title cell
- `#VSC-3b0ecd02` - Install cell
- `#VSC-c4649e9f` - Import cell
- `#VSC-3beaaf96` - Config cell
- Generate new random 8-char hex IDs for new cells

### 4. NO Raw JSON Format
❌ **NEVER USE:**
```json
{
  "cells": [
    {
      "cell_type": "markdown",
      ...
```

✅ **ALWAYS USE:**
```xml
<VSCode.Cell id="#VSC-xxx" language="markdown">
...
</VSCode.Cell>
```

---

## 🚀 HOW TO CREATE NEW NOTEBOOKS

### Method 1: Copy Template (RECOMMENDED)
```bash
cp NOTEBOOK_TEMPLATE.ipynb new_notebook.ipynb
# Edit content, keep structure
```

### Method 2: Copy from Working Notebook
```bash
# Copy from Phase 1 (GPU) or TPU test
cp phase1_training.ipynb new_notebook.ipynb
# Modify cells, keep format
```

### Method 3: Start from Scratch (DANGEROUS)
**Only if you must:**
1. Create first cell with proper XML format
2. Copy cell structure from NOTEBOOK_TEMPLATE.ipynb
3. Generate new cell IDs (random 8-char hex)
4. Test with `kaggle kernels push` immediately

---

## ⚠️ COMMON MISTAKES (DON'T DO THESE!)

### ❌ Missing Cell IDs
```xml
<VSCode.Cell language="python">  <!-- WRONG - no id -->
```

### ❌ Wrong ID Format
```xml
<VSCode.Cell id="abc123" language="python">  <!-- WRONG - missing #VSC- prefix -->
```

### ❌ Using JSON Format
```json
{
  "cells": [...],  <!-- WRONG - Kaggle rejects this -->
  "metadata": {...}
}
```

### ❌ Missing Language Attribute
```xml
<VSCode.Cell id="#VSC-123">  <!-- WRONG - no language -->
```

---

## 📝 TESTING CHECKLIST

Before pushing ANY notebook:

- [ ] Used NOTEBOOK_TEMPLATE.ipynb or copied from working notebook
- [ ] All cells have `id="#VSC-xxxxxxxx"` format
- [ ] All cells have `language="python"` or `language="markdown"`
- [ ] No raw JSON structure
- [ ] File is valid XML
- [ ] Saved in VS Code (Ctrl+S)
- [ ] kernel-metadata.json has correct kernel ID

---

## 🎯 GOLDEN RULE

**When in doubt: Copy NOTEBOOK_TEMPLATE.ipynb and modify content only!**

**NEVER create notebooks from scratch using JSON format!**

**ALWAYS verify notebook structure matches NOTEBOOK_TEMPLATE.ipynb before pushing!**

---

## 📚 Working Examples

1. **NOTEBOOK_TEMPLATE.ipynb** - Base template (TPU test structure)
2. **phase1_training.ipynb** - Working Phase 1 (GPU)
3. **tpu_compatibility_test.ipynb** - Working TPU test (v2)

Copy from these ONLY.

---

**Last Updated:** October 6, 2025  
**Reason:** After 17 failed notebook attempts due to format issues  
**Status:** MANDATORY for all future work
