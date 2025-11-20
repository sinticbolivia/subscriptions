# Compilation

Parameters description.

path_sinticbolivia_lib: Needs to be an absolute path

## Debug compilation

```
meson setup build -Dlibsinticbolivia=[path_sinticbolivia_lib]
cd build
meson compile
```

## Release compilation

```
meson setup build --builtype=release -Dlibsinticbolivia=[path_sinticbolivia_lib]
cd build
meson compile
```
