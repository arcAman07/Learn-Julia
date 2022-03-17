using FastAI

data, blocks = loaddataset("imagenette2-160", (Image, Label))
method = ImageClassificationSingle(blocks)
learner = methodlearner(method, data, callbacks=[ToGPU()])
fitonecycle!(learner, 10)
showoutputs(method, learner)










