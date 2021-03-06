is_index_null <- function(x) {
  if (is_null(x %@% "index")) {
    abort("The `index` has been dropped somehow. Please reconstruct tsibble.")
  }
}

dont_know <- function(x, FUN) {
  cls <- class(x)[1]
  msg <- sprintf(
    "`%s()` doesn't know how to handle the %s class yet.", FUN, cls
  )
  abort(msg)
}

abort_unknown_interval <- function(x) {
  if (unknown_interval(x)) {
    abort(sprintf("`%s` can't proceed with tsibble of unknown interval.",
      deparse(sys.call(-1))))
  }
}

abort_if_irregular <- function(x) {
  if (!is_regular(x)) {
    abort(sprintf("`%s` can't handle tsibble of irregular interval.",
      deparse(sys.call(-1))))
  }
}

not_tsibble <- function(x) {
  if (!is_tsibble(x)) {
    abort(sprintf("%s is not a tsibble.", deparse(substitute(x))))
  }
}

check_valid_window <- function(.size, .align) {
  if (is_even(.size) && .align %in% c("c", "centre", "center")) {
    abort(sprintf(
      "Can't use `.align = %s` for even window `.size`.\nPlease specify `.align = 'center-left'` or `.align = 'center-right'`.",
      .align
    ))
  }
}

abort_not_lst <- function(.x, .bind = FALSE) {
  if (!is.list(.x) && .bind) {
    abort(sprintf("`.bind = TRUE` only accepts list, not %s.", typeof(.x)))
  }
}

bad_window_function <- function(.size) {
  if (!is_integerish(.size, n = 1)) {
    abort("`.size` must be an integer.")
  }
  if (.size == 0) {
    abort("`.size` must not be 0.")
  }
}

bad_step_function <- function(.step) {
  if (.step <= 0 || !is_integerish(.step, n = 1)) {
    abort("`.step` must be a positive integer.")
  }
}

pkg_not_available <- function(pkg, min_version = NULL) {
  pkg_lgl <- requireNamespace(pkg, quietly = TRUE)
  if (!pkg_lgl) {
    if (is_null(min_version)) {
      abort(sprintf("Package `%s` required.\nPlease install and try again.", pkg))
    } else if (utils::packageVersion(pkg) >= min_version) {
      abort(sprintf(
        "Package `%s` (>= v%s) required.\nPlease install and try again.", 
        pkg, min_version))
    }
  }
}
