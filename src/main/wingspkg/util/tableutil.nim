import sets
import tables

proc merge*[A, B](first: Table[A, B], second: Table[A, B], ignoreDup: bool = true): Table[A, B] =
    ## Merge `first` and `second` into a single `Table[A, B]`.
    ## Exception will be thrown if there are different values with the same key between the two tables.
    ## If `ignoreDup` is set to `false`, duplicated keys from the two tables will also throw an exception.
    result = first

    for key in second.keys:
        if result.contains(key):
            if result[key] != second[key]:
                raise newException(Exception, "Value of the same key from one table is different from the other.")

            if not ignoreDup:
                raise newException(Exception, "Unable to join tables with duplicate key.")
        else:
            result.add(key, second[key])

proc merge*[T](first: HashSet[T], second: HashSet[T]): HashSet[T] =
    ## Merge `first` and `second` into a single `HashSet[T]`.
    result = first

    for item in second.items:
        result.incl(item)
