import numpy as np
import matplotlib.pyplot as plt

plt.imshow(np.fromfile("map.bin").reshape(401, 401))
plt.rcParams['image.cmap'] = 'gray'
plt.imshow(np.fromfile("eps.bin").reshape(401, 401), alpha=0.1)
plt.show()