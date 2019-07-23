#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/**
 * arguments for funtions described with `Command_r`
 */
typedef union {
  int i;
  unsigned int ui;
  float f;
  const void *v;
} Arg_r;

/**
 * Command struct holding a command to execute
 */
typedef struct {
  const char *name;
  void (*func)(const Arg_r *arg);
  Arg_r arg;
} Command_r;

int init_rwm(const char *path, const Command_r *commands, int len);

int quit_rwm(void);

int run_rwm(void);
