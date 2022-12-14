import argparse

import pytorch_lightning as pl
from pytorch_lightning.plugins import DDPPlugin
from pytorch_lightning.loggers import WandbLogger
from pytorch_lightning.callbacks import ModelCheckpoint

from control_simp.data.bart import BartDataModule
from control_simp.data.bert import BertDataModule
from control_simp.models.end_to_end import BartFinetuner
from control_simp.models.classification import LightningBert

ARCHS = {
    "bart": {
        "module": BartFinetuner,
        "datam": BartDataModule,
    },
    "classifier": {
        "module": LightningBert,
        "datam": BertDataModule,
    },
}


if __name__ == '__main__':
    """
    Train a specified model.
    """

    # prepare argument parser
    parser = argparse.ArgumentParser()
    parser.add_argument("--arch", type=str, default=None, required=True)
    args = parser.parse_known_args()[0]
    arch_classes = ARCHS[args.arch]

    # add model specific args to parser
    parser = arch_classes["module"].add_model_specific_args(parser)

    # add all the available trainer options to argparse
    # ie: now --gpus --num_nodes ... --fast_dev_run all work in the cli
    parser = pl.Trainer.add_argparse_args(parser)
    args = parser.parse_args()

    # prepare data module and trainer class
    if args.checkpoint is None:
        if args.arch == "bart":
            model = arch_classes["module"](mtl=args.use_mtl_toks, hparams=args)
        else:
            model = arch_classes["module"](hparams=args)
    else:
        if args.arch == "bart":
            model = arch_classes["module"].load_from_checkpoint(args.checkpoint, mtl=args.use_mtl_toks, hparams=args)
        else:
            model = arch_classes["module"].load_from_checkpoint(args.checkpoint, hparams=args)
    dm = arch_classes["datam"](model.tokenizer, hparams=args)

    # construct default run name
    if args.name is None:
        args.name = f"{args.max_samples}_{args.batch_size}_{args.learning_rate}"

    # prepare logger
    wandb_logger = WandbLogger(
        name=args.name, project=args.project, save_dir=args.save_dir, id=args.wandb_id)

    # checkpoint callback
    checkpoint_callback = ModelCheckpoint(monitor="val_loss")

    trainer = pl.Trainer.from_argparse_args(
        args,
        val_check_interval=args.val_check_interval,
        logger=wandb_logger,
        accelerator="ddp",
        strategy=DDPPlugin(find_unused_parameters=False),
        callbacks=[checkpoint_callback],
        precision=16,)

    trainer.fit(model, dm)
