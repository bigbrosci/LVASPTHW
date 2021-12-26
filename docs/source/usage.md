# Contents

(installation)=

## Installation

To use Lumache, first install it using pip:

```console
(.venv) $ pip install lumache
```

## Creating recipes

To retrieve a list of random ingredients,
you can use the `lumache.get_random_ingredients()` function:

```{eval-rst}
.. autofunction:: lumache.get_random_ingredients
```

The `kind` parameter should be either `"meat"`, `"fish"`,
or `"veggies"`. Otherwise, {py:func}`lumache.get_random_ingredients`
will raise an exception.

```{eval-rst}
.. autoexception:: lumache.InvalidKindError
```

For example:

>>> import lumache
>>> lumache.get_random_ingredients()
\['shells', 'gorgonzola', 'parsley'\]
