# Compilation

Parameters description.

path_sinticbolivia_lib: Needs to be an absolute path

## Debug compilation

```
meson setup build -Dlibsinticbolivia=[path_sinticbolivia_lib]
cd build
meson compile
```

For DEBUG, your needs to execute the launcher or API application using G_MESSAGES_DEBUG=all

Example:

```
G_MESSAGES_DEBUG=all ./api
```

## Release compilation

```
meson setup build --builtype=release -Dlibsinticbolivia=[path_sinticbolivia_lib]
cd build
meson compile
```
