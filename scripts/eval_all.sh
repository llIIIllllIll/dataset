# 4-class end-to-end
python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/3fn5qcza/checkpoints/epoch\=0.ckpt \
/media/liam/data2/discourse_data/simp_clf_data/gen/control_simp_valid_exp1_clf.csv /media/liam/data2/control_simp_ckps/3fn5qcza \
plain --samsa=False --ow=True

python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/3fn5qcza/checkpoints/epoch\=0.ckpt \
/media/liam/data2/simp_data/newsela-auto/newsela-auto/ACL2020/test_clf.csv /media/liam/data2/control_simp_ckps/3fn5qcza \
newsela --samsa=False --ow=True

# 3-class end-to-end
python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/d68v4v5z/checkpoints/epoch=3-step=259528.ckpt \
/media/liam/data2/discourse_data/simp_clf_data/gen/control_simp_valid_exp1_clf.csv /media/liam/data2/control_simp_ckps/d68v4v5z \
plain --samsa=False --ow=True

python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/d68v4v5z/checkpoints/epoch=3-step=259528.ckpt \
/media/liam/data2/simp_data/newsela-auto/newsela-auto/ACL2020/test_clf.csv /media/liam/data2/control_simp_ckps/d68v4v5z \
newsela --samsa=False --ow=True

# 4-class ctrl-token
python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/12s3nazz/checkpoints/epoch\=6-step\=166580.ckpt \
/media/liam/data2/discourse_data/simp_clf_data/gen/control_simp_valid_exp1_clf.csv /media/liam/data2/control_simp_ckps/12s3nazz/ \
clf --ctrl_toks=pred_l --samsa=False --ow=True

python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/12s3nazz/checkpoints/epoch\=6-step\=166580.ckpt \
/media/liam/data2/discourse_data/simp_clf_data/gen/control_simp_valid_exp1_clf.csv /media/liam/data2/control_simp_ckps/12s3nazz/ \
oracle --ctrl_toks=label --samsa=False --ow=True

python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/12s3nazz/checkpoints/epoch\=6-step\=166580.ckpt \
/media/liam/data2/simp_data/newsela-auto/newsela-auto/ACL2020/test_clf.csv /media/liam/data2/control_simp_ckps/12s3nazz \
newsela --ctrl_toks=pred_l --samsa=False --ow=True

python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/12s3nazz/checkpoints/epoch\=6-step\=166580.ckpt \
/media/liam/data2/simp_data/newsela-auto/newsela-auto/ACL2020/test_clf.csv /media/liam/data2/control_simp_ckps/12s3nazz/ \
newsela_oracle --ctrl_toks=label --samsa=False --ow=True

# 3-class ctrl-token
python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/25ldpr2h/checkpoints/epoch\=8-step\=170317.ckpt \
/media/liam/data2/discourse_data/simp_clf_data/gen/control_simp_valid_exp1_clf.csv /media/liam/data2/control_simp_ckps/12s3nazz/ \
clf --ctrl_toks=pred_l --samsa=False --ow=True

python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/25ldpr2h/checkpoints/epoch\=8-step\=170317.ckpt \
/media/liam/data2/discourse_data/simp_clf_data/gen/control_simp_valid_exp1_clf.csv /media/liam/data2/control_simp_ckps/12s3nazz/ \
oracle --ctrl_toks=label --samsa=False --ow=True

python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/25ldpr2h/checkpoints/epoch\=8-step\=170317.ckpt \
/media/liam/data2/simp_data/newsela-auto/newsela-auto/ACL2020/test_clf.csv /media/liam/data2/control_simp_ckps/12s3nazz \
newsela --ctrl_toks=pred_l --samsa=False --ow=True

python control_simp/models/eval.py bart /media/liam/data2/control_simp_ckps/25ldpr2h/checkpoints/epoch\=8-step\=170317.ckpt \
/media/liam/data2/simp_data/newsela-auto/newsela-auto/ACL2020/test_clf.csv /media/liam/data2/control_simp_ckps/12s3nazz/ \
newsela_oracle --ctrl_toks=label --samsa=False --ow=True