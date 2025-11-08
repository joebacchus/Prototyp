# Prototyp

A set of configurations and tools for quickly initialising scientific computing environments and typesetting.

## Usage

Currently, this configuration is designed for a specific workflow so a lot of it is poorly generalised and hard-coded. The essential scripts are written for **nushell**. 

To setup, create a folder called `experiments`, and within this, create another called `.setup` in which you place the contents of this repo. Now, add the following commands to your nushell path.

```bash
alias prototyp-config = nu "<path to folder>/experiments/.setup/locate.nu"

alias prototyp-delete = nu "<path to folder>/experiments/.setup/delete.nu"

alias prototyp = nu "<path to folder>/experiments/.setup/setup.nu"
```

The idea is to consider the essential components for fast prototyping and experimentation in research. Usually, we are interested in producing a written paper that contains plots and coded experiments, produced in one language, into another typesetted. Whilst this codebase contains a method for quickly initialising this space to work in, it also includes a way of naturally exchanging objects such as variables, plots and tables between the programming language and the typesetter. 

This specific approach considers the following tools.
 
| Category | Tool/Library | Description |
| :--- | :--- | :--- |
| IDE | VSCode | The main environment to manage the project and load files within to write. |
| Package Manager | Pixi | The system we use to manage our external dependencies. |
| Packages | Matplotlib, Numpy, Pandas, Pytorch, NetworkX, Ipykernel, Scienceplots | A standard set of external dependencies that I personally find essential for most areas of my workflow |
| Version Control | Jujutsu | The system we use to ensure that we can always go back on changes we make, and other nice stuff. |
| Programming | Python (Jupyter Notebook) | Our main language for computing and running results, it also produces the figures for some of these. |
| typesetting | Typst | The main language for writing mathematics and formatting a document containg our experiment. |

## Configurations

To allow for our commands to work, modify paths, and GitHub username, so that they are correctly pointing to your own in `setup.nu`, `delete.nu` and `locate.nu`.

Within this `.setup` folder, it is the template folder that is copied over upon create of a new workspace. 

## Commands

To initialise a new project run 

```bash 
prototyp <project_name>
```

This will create a vscode workspace with a template containing  a lightweight set of essential tools for working on a project, and the mechanism for exchanging data. It also creates a github repo of the same name. If we then wanted to ever delete one of these we can use

```bash
prototyp-delete <project_name>
```

This is a quick way to quickly delete both the local folder and the github repo of this project. Finally, for accessing this configuation directory we can run

```bash
prototyp-config
```

This will just open the `.setup` folder in a vscode workspace.

## Sharing objects

Within **Python**, one can assign _variables_ (JSON compatible), _plots_ (Matplotlib SVGs) and _tables_ (DataFrame CSVs), into a shared space as follows. We have one of these objects `object` and want to store this as `x`, so we call

```python
share.x = object
```

It is now simply a matter of calling in **Typst**

```typst
#share.x
```

This retrieves the object. It really is that simple.
