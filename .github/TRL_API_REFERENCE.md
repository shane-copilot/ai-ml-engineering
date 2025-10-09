# TRL (Transformer Reinforcement Learning) API Reference

**Last Updated:** October 8, 2025  
**Library:** huggingface/trl  
**Purpose:** Latest API reference for training transformer models with reinforcement learning

---

## SFTTrainer (Supervised Fine-Tuning Trainer)

### Basic Usage

```python
from trl import SFTTrainer
from datasets import load_dataset

dataset = load_dataset("trl-lib/Capybara", split="train")

trainer = SFTTrainer(
    model="Qwen/Qwen2.5-0.5B",
    train_dataset=dataset,
)
trainer.train()
```

### Key Parameters

- **model**: Model identifier string or pre-loaded model
- **tokenizer**: Required - pass explicitly (formerly `processing_class`)
- **train_dataset**: Training dataset
- **eval_dataset**: Optional validation dataset
- **formatting_func**: Function to extract text from dataset (replaces deprecated `dataset_text_field`)
- **peft_config**: Optional LoRA/PEFT configuration
- **args**: SFTConfig object with training arguments

### CRITICAL API CHANGE (Latest TRL)

**Old (deprecated):**
```python
trainer = SFTTrainer(
    model=model,
    dataset_text_field="text",  # ❌ No longer supported
)
```

**New (current):**
```python
trainer = SFTTrainer(
    model=model,
    tokenizer=tokenizer,  # ✅ Required
    formatting_func=lambda x: x["text"],  # ✅ Extract text field
)
```

### Dataset Formats

SFTTrainer accepts 4 dataset formats:

1. **Standard language modeling:**
```python
{"text": "The sky is blue."}
```

2. **Conversational language modeling:**
```python
{"messages": [
    {"role": "user", "content": "What color is the sky?"},
    {"role": "assistant", "content": "It is blue."}
]}
```

3. **Standard prompt-completion:**
```python
{"prompt": "The sky is", "completion": " blue."}
```

4. **Conversational prompt-completion:**
```python
{
    "prompt": [{"role": "user", "content": "What color is the sky?"}],
    "completion": [{"role": "assistant", "content": "It is blue."}]
}
```

### Training with PEFT/LoRA

```python
from peft import LoraConfig

trainer = SFTTrainer(
    "Qwen/Qwen3-0.6B",
    train_dataset=dataset,
    peft_config=LoraConfig(
        r=16,
        lora_alpha=32,
        target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
        lora_dropout=0.05,
        bias="none",
        task_type="CAUSAL_LM"
    )
)
trainer.train()
```

### Instruction Tuning with Chat Templates

```python
from trl import SFTTrainer, SFTConfig

trainer = SFTTrainer(
    model="Qwen/Qwen3-0.6B-Base",
    args=SFTConfig(
        output_dir="Qwen3-0.6B-Instruct",
        chat_template_path="HuggingFaceTB/SmolLM3-3B",
    ),
    train_dataset=load_dataset("trl-lib/Capybara", split="train"),
)
trainer.train()
```

### Training on Specific Parts

**Train on assistant messages only (conversational):**
```python
training_args = SFTConfig(assistant_only_loss=True)
```

**Train on completion only (prompt-completion):**
```python
training_args = SFTConfig(completion_only_loss=True)  # Default behavior
```

**Combined (conversational prompt-completion):**
```python
training_args = SFTConfig(
    assistant_only_loss=True,
    completion_only_loss=True
)
```

---

## SFTConfig

### Essential Parameters

```python
from trl import SFTConfig

training_args = SFTConfig(
    output_dir="./output",
    
    # Training
    num_train_epochs=3,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=5e-5,
    weight_decay=0.1,
    
    # Optimization
    fp16=True,  # or bf16=True
    optim="paged_adamw_8bit",
    max_grad_norm=1.0,
    
    # Evaluation
    eval_strategy="steps",
    eval_steps=100,
    
    # Saving
    save_strategy="steps",
    save_steps=100,
    save_total_limit=2,
    
    # Memory optimization
    gradient_checkpointing=True,
    max_length=2048,
    
    # Model initialization
    model_init_kwargs={"torch_dtype": "bfloat16"},
)
```

### Memory Reduction Features

**Padding-free batching:**
```python
training_args = SFTConfig(
    padding_free=True,
    model_init_kwargs={"attn_implementation": "flash_attention_2"}
)
```

**Packing (group sequences, reduce padding):**
```python
training_args = SFTConfig(
    packing=True,
    max_length=512
)
```

**Activation offloading:**
```python
training_args = SFTConfig(
    activation_offloading=True
)
```

**Liger Kernel (memory optimization):**
```python
training_args = SFTConfig(
    use_liger_kernel=True
)
```

---

## Common Patterns

### Full Example with All Best Practices

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig
from datasets import load_dataset
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from trl import SFTTrainer, SFTConfig

# Load tokenizer
tokenizer = AutoTokenizer.from_pretrained("Qwen/Qwen3-0.6B")
tokenizer.pad_token_id = tokenizer.eos_token_id
tokenizer.padding_side = "right"

# Load model with 4-bit quantization
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=True
)

model = AutoModelForCausalLM.from_pretrained(
    "Qwen/Qwen3-0.6B",
    quantization_config=bnb_config,
    device_map="auto",
    trust_remote_code=True
)

# Prepare for LoRA training
model = prepare_model_for_kbit_training(model, use_gradient_checkpointing=True)

# Apply LoRA
lora_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)
model = get_peft_model(model, lora_config)

# Load and format dataset
dataset = load_dataset("your-dataset", split="train")

def format_chat_template(example):
    messages = [
        {"role": "user", "content": example["instruction"]},
        {"role": "assistant", "content": example["output"]}
    ]
    text = tokenizer.apply_chat_template(
        messages,
        tokenize=False,
        add_generation_prompt=False
    )
    return {"text": text}

dataset = dataset.map(format_chat_template)

# Training arguments
training_args = SFTConfig(
    output_dir="./output",
    num_train_epochs=3,
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=5e-5,
    weight_decay=0.1,
    fp16=True,
    optim="paged_adamw_8bit",
    eval_strategy="steps",
    eval_steps=100,
    save_strategy="steps",
    save_steps=100,
    save_total_limit=2,
    max_grad_norm=1.0,
    warmup_ratio=0.03,
    lr_scheduler_type="cosine",
    logging_steps=10,
    report_to="none",
)

# Create trainer
trainer = SFTTrainer(
    model=model,
    tokenizer=tokenizer,
    args=training_args,
    train_dataset=dataset,
    formatting_func=lambda x: x["text"],
)

# Train
trainer.train()
```

### Continue Training Existing PEFT Model

```python
from peft import AutoPeftModelForCausalLM

model = AutoPeftModelForCausalLM.from_pretrained(
    "path/to/peft/model",
    is_trainable=True
)

trainer = SFTTrainer(
    model=model,
    train_dataset=dataset,
    # No peft_config needed - already applied
)
trainer.train()
```

---

## Integration with Unsloth

```python
from unsloth import FastLanguageModel
from trl import SFTConfig, SFTTrainer

# Load model with Unsloth
model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/mistral-7b",
    max_seq_length=2048,
    dtype=None,
    load_in_4bit=True,
)

# Apply PEFT
model = FastLanguageModel.get_peft_model(
    model,
    r=16,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj", 
                    "gate_proj", "up_proj", "down_proj"],
    lora_alpha=16,
    lora_dropout=0,
    bias="none",
    use_gradient_checkpointing=True,
)

training_args = SFTConfig(output_dir="./output", max_length=2048)

trainer = SFTTrainer(
    model=model,
    args=training_args,
    train_dataset=dataset,
)
trainer.train()
```

---

## Vision-Language Models (VLMs)

### Special Configuration for VLMs

```python
training_args.remove_unused_columns = False
training_args.dataset_kwargs = {"skip_prepare_dataset": True}

trainer = SFTTrainer(
    model=model,
    args=training_args,
    data_collator=collate_fn,
    train_dataset=train_dataset,
    processing_class=processor,  # Use processor instead of tokenizer
)
```

---

## Other Trainers

### DPOTrainer (Direct Preference Optimization)

```python
from trl import DPOConfig, DPOTrainer

model = AutoModelForCausalLM.from_pretrained("Qwen/Qwen2.5-0.5B-Instruct")
tokenizer = AutoTokenizer.from_pretrained("Qwen/Qwen2.5-0.5B-Instruct")
dataset = load_dataset("trl-lib/ultrafeedback_binarized", split="train")

training_args = DPOConfig(output_dir="Qwen2.5-0.5B-DPO")

trainer = DPOTrainer(
    model=model,
    args=training_args,
    train_dataset=dataset,
    processing_class=tokenizer
)
trainer.train()
```

### GRPOTrainer (Group Relative Policy Optimization)

```python
from trl import GRPOTrainer

def reward_num_unique_chars(completions, **kwargs):
    return [len(set(c)) for c in completions]

trainer = GRPOTrainer(
    model="Qwen/Qwen2-0.5B-Instruct",
    reward_funcs=reward_num_unique_chars,
    train_dataset=dataset,
)
trainer.train()
```

### RewardTrainer (Reward Modeling)

```python
from trl import RewardConfig, RewardTrainer

model = AutoModelForSequenceClassification.from_pretrained(
    "Qwen/Qwen2.5-0.5B-Instruct",
    num_labels=1
)
model.config.pad_token_id = tokenizer.pad_token_id

training_args = RewardConfig(
    output_dir="Qwen2.5-0.5B-Reward",
    per_device_train_batch_size=2
)

trainer = RewardTrainer(
    args=training_args,
    model=model,
    processing_class=tokenizer,
    train_dataset=dataset,
)
trainer.train()
```

---

## Key API Changes to Remember

1. **`dataset_text_field` is deprecated** → Use `formatting_func`
2. **`tokenizer` parameter is required** (not optional)
3. **`processing_class`** is the new name for tokenizer in some contexts
4. **Chat templates** are now the recommended way to format conversational data
5. **`model_init_kwargs`** for passing arguments to model initialization

---

## Common Errors and Solutions

### Error: "unexpected keyword argument 'dataset_text_field'"
**Solution:** Use `formatting_func` instead:
```python
trainer = SFTTrainer(
    model=model,
    tokenizer=tokenizer,
    formatting_func=lambda x: x["text"],
)
```

### Error: KeyError: 'completion'
**Solution:** Your dataset needs a "text" field or use `formatting_func`:
```python
def format_func(example):
    return {"text": example["your_text_field"]}

dataset = dataset.map(format_func)
```

### Error: Padding token not set
**Solution:** Always set padding token:
```python
tokenizer.pad_token_id = tokenizer.eos_token_id
tokenizer.padding_side = "right"
```

---

## Resources

- **Official Docs:** https://huggingface.co/docs/trl
- **GitHub:** https://github.com/huggingface/trl
- **Examples:** https://github.com/huggingface/trl/tree/main/examples
