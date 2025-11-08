from cycler import cycler
import matplotlib as mpl
import scienceplots
import networkx as nx
import numpy as np
import pandas as pd
import torch as th
import json
import os
from io import StringIO
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from pandas import DataFrame

def is_jsonable(x):
    try:
        json.dumps(x)
        return True
    except (TypeError, OverflowError):
        return False
    
class Shared:

    def __init__(self, path):
        self.path = path

    def __setattr__(self, name, value):
        super().__setattr__(name, value)

        with open(self.path, "r") as file:
            data = json.load(file)

        if isinstance(value, Figure):
            serialised = StringIO()
            plt.savefig(serialised, format="svg")
            text = serialised.getvalue()
            data[name] = ("svg", None, text)
            plt.close()

        elif isinstance(value, DataFrame):
            serialised = StringIO()
            value.to_csv(serialised, index=False)
            text = serialised.getvalue()
            data[name] = ("csv", value.shape, text)
            plt.close()

        elif is_jsonable(value):
            data[name] = (str(type(value)), None, value)
            
        else:
            raise TypeError(
                f"value of type {type(value)} is not serialisable.")

        with open(self.path, "w") as file:
            json.dump(data, file, indent=4)


share = Shared("sharables/objects.json")


os.environ["PATH"] = "/Library/TeX/texbin:" + os.environ["PATH"]


plt.style.use('science')


n_colors = 4
cmap_name = "inferno"

cmap = plt.get_cmap(cmap_name)
cmap_colors = colors = [cmap(i / (n_colors - 1)) for i in range(n_colors)]
mpl.rcParams['axes.prop_cycle'] = cycler(color=cmap_colors)
mpl.rcParams['image.cmap'] = cmap_name
