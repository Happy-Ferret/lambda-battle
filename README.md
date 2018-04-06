# lambda-battle

A comparison of lambda term representations, abstract machines, etc.

## Installing

### Prerequisites

| prerequisite |      | version                                                                | how to install                  |
| ------------ | ---- | :--------------------------------------------------------------------- | ------------------------------- |
| Opam         | `>=` | [`1.2.2`](https://github.com/ocaml/opam/releases/tag/1.2.2)            | manually or via package manager |
| OCaml        | `>=` | [`4.06.1+flambda`](https://github.com/ocaml/ocaml/releases/tag/4.06.1) | `opam switch 4.06.1+flambda`    |
| odoc         | `>=` | [`1.2.0`](https://github.com/ocaml/odoc/releases/tag/v1.2.0)           | `opam install odoc` (optional)  |
| utop         | `>=` | [`2.0.2`](https://github.com/diml/utop/releases/tag/2.0.2)             | `opam install utop` (optional)  |

### Installing Dependencies

```
$ git clone https://github.com/freebroccolo/lambda-battle
$ cd lambda-battle
$ opam update
$ opam pin add -y .
```

### Building

```
$ make
```

### Documentation

Requires `odoc` (see prerequisites).

```
$ make doc
```

### Toplevel

Requires `utop` (see prerequisites).

```
$ make top
```

## Contributing

Please see the following documents.

* [Code of Conduct](CODE_OF_CONDUCT.md)
* [Contributing](CONTRIBUTING.md)
