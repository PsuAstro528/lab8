# Astro 528 Lab 8
## GPU Computing

For this lab, you will need to request a compute node that has a CUDA-enabled GPU.  There are two options:
- Log in as usual.  Rather than working direclty in a notebook, submit a short slurm job  (e.g., at the shell run `sbatch ex1.slurm`), and then view the output file (e.g., ex1.html) in your webbrowser.  The good part of this approach is that you'll only need to use a GPU for a few minutes and then make it avaliable to someone else.  This may be necessary if there are more students in class than GPUs avaliable to the class.  

- Request dedicated access to a GPU for your entire session.  For this option, when you are on the HPC for Astro Jupyter App page to create your JupyterLab session, click "Enable advanced Slurm options" and then type `--gres=gpu:1` in the Sbatch options before clicking launch.  This allows you to interactively run commands on the GPU.  The downside of this option is that it blocks others from accessing "your" GPU until you close your session, even though you're likely not using the GPU most of the time.


## Exercise 1:  GPU Computing I: Getting Started with GPU Computing & Linear Algebra
### Goals:  
- Run GPU code
- Accelerate linear algebra computations with GPU 
- Recognize what problem sizes and likely to result in acceleration with a GPU for linear algebra

Work through ex1.ipynb, either in the Jupyter notebook or by submitting ex1.slurm and viewing the output html file.  

## Exercise 2:  GPU Computing II: GPU Kernels, Reductions
### Goals:  
- Perform custom scientific computations using a high-level GPU interface
- Improve performance by reducing kernel launches via broadcasting and GPU kernel fusion
- Improve performance by reducing memory transfers via GPU reductions
- Recognize what types of problems and problem sizes are likely to result in acceleration with a GPU  when using a custom kernel
Work through ex2.ipynb, either in the Jupyter notebook or by submitting ex2.slurm and viewing the output html file.  

## Submitting your lab
Saving, adding, commiting, and pushing `ex1.ipynb` and `ex2.ipynb` is useful for sharing the plots created.  However, it's difficult to isolate the changes you made to the notebooks in GitHub due to all the formatting of ipynb files.  Therefore, when you're done with the lab, please also add, commit and push a markdown version of your responces to your repository.

If you entered your responces in `ex1.ipynb` and `ex2.ipynb`, then you can run
```shell
julia --project=. -e 'using Weave; convert_doc("ex1.ipynb","ex1.jmd")'
julia --project=. -e 'using Weave; convert_doc("ex2.ipynb","ex2.jmd")'
```
to convert the ipynb files into a jmd files (instead of html files), and then commit and push the `ex?.jmd` files like
```shell
git add ex1.jmd ex2.jmd
git commit -m "Adding markdown version of updated Jupyter notebooks"
git push
```

Alternatively, if you entered your responces in `ex1_responces.md` and `ex2_responces.md`, then you can simply 
```shell
git add ex1_responces.md ex2_responces.md
git commit -m "Adding markdown files with responces"
git push
```

Either way, it would also be helpful to add and commit the figures your scripts generated (in case your responses don't match what I'm expecting).
```shell
git add benchmarks_*.png 
git commit -m "Adding figure"
git push
```


