# Controllable Simplification via Operation Classification

This repo contains code and data used to run experiments presented in the NAACL 2022 paper, [Controllable Sentence Simplification via Operation Classification](https://aclanthology.org/2022.findings-naacl.161/).

## IRSD data

The IRSD dataset is available in [data/](data/). The publicly available version does not include any examples from Newsela-auto. To access the Newsela-auto examples, please obtain a licence from Newsela before contacting the authors directly.

## Pretrained models

Pretrained PyTorch models for the 4-class operation classifier and controllable simplification model are available on [HuggingFace](https://huggingface.co/liamcripwell).

To use the classifier:

```python
from transformers import RobertaForSequenceClassification, AutoTokenizer

model = RobertaForSequenceClassification.from_pretrained("liamcripwell/ctrl44-clf")
tokenizer = AutoTokenizer.from_pretrained("liamcripwell/ctrl44-clf")

text = "Barack Hussein Obama II is an American politician who served as the 44th president of the United States from 2009 to 2017."
inputs = tokenizer(text, return_tensors="pt")

with torch.no_grad():
  logits = model(**inputs).logits
predicted_class_id = logits.argmax().item()
predicted_class_name = model.config.id2label[predicted_class_id]
```

To use the controllable simplification model:

```python
from transformers import BartForConditionalGeneration, AutoTokenizer

model = BartForConditionalGeneration.from_pretrained("liamcripwell/ctrl44-simp")
tokenizer = AutoTokenizer.from_pretrained("liamcripwell/ctrl44-simp")

text = "<para> Barack Hussein Obama II is an American politician who served as the 44th president of the United States from 2009 to 2017."
inputs = tokenizer(text, return_tensors="pt")
outputs = model.generate(**inputs, num_beams=10, max_length=128)
```

## Training models

The following is an example of how to train a RoBERTa-based operation classifier:

```bash
doc_simp/models/train.py --data_file=<train_file.csv> --val_file=<val_file.csv> --learning_rate=3e-5 --x_col=complex --y_col=label --batch_size=32 --arch=classifier --model_type=roberta
```

Generative models can be trained as follows:

```bash
python control_simp/models/train.py --arch=bart --data_file=<train_file.csv> --val_file=<val_file.csv> --learning_rate=3e-5 --batch_size=16 --max_source_length=128 --max_target_length=128 --eval_beams=4 --x_col=complex --y_col=simple 
```

See the source code for additional arguments.

## Evaluating models

Operation classifiers can be run from the terminal as follows (`test_file` should be a `.csv`):

```bash
python control_simp/models/eval.py clf <model_ckpt> <test_file> <out_file> --input_col=<sentence_col>
```

Generative models can be used for inference/evaluation in a similar fashion. For pipeline models, operation control tokens are dictated from a column in the input data specified via the `--ctrl_toks` flag. Disabling SAMSA with `--samsa=False` dramatically reduces runtime.

```bash
# End-to-End Model
python control_simp/models/eval.py bart <model_ckpt> <test_file> <output_dir> <run_name> --samsa=False

# CTRL Model
python control_simp/models/eval.py bart <model_ckpt> <test_file> <output_dir> <run_name> --ctrl_toks=<label_col> --samsa=False
```

## Citation

If you find this repository useful, please cite our publication [Controllable Sentence Simplification via Operation Classification](https://aclanthology.org/2022.findings-naacl.161/).

```bibtex
@inproceedings{cripwell-etal-2022-controllable,
    title = "Controllable Sentence Simplification via Operation Classification",
    author = {Cripwell, Liam  and
      Legrand, Jo{\"e}l  and
      Gardent, Claire},
    booktitle = "Findings of the Association for Computational Linguistics: NAACL 2022",
    month = jul,
    year = "2022",
    address = "Seattle, United States",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2022.findings-naacl.161",
    pages = "2091--2103",
}

```
