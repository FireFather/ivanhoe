
EPONYM = IvanHoe
VERSION = 999946h-RL
CC = gcc
FLAGS = -Wall -I../include/ # novel
OPTIONS = -g -O3 -fstrict-aliasing -fomit-frame-pointer -fno-exceptions

HAS = -DHAS_POPCNT # -DHAS_PREFETCH
HAS = # -DHAS_PREFETCH # comment out when HAS_POPCNT can avail
DEFINITIONS = -Dx86_64 $(HAS) -DVERSION=\"$(VERSION)\"
DEFINITIONS += -DEPONYM=\"$(EPONYM)\"
DEFINITIONS += -DCON_ROBBO_BUILD # RobboBases usage
DEFINITIONS += -DCHESS_960 # novel !
# DEFINITIONS += -DNOME_WINDOWS # uncomment for RobboBuild with WINDOWS names

DEFINITIONS += -DYUSUF_MULTICORE # capitalist!
# DEFINITIONS += -DUSER_SPLIT # allow capitalist users to split nodes
# DEFINITIONS += -DMINIMAL # for MINIMAL
# DEFINITIONS += -DWINDOWS # for WINDOWS
# DEFINITIONS += -DDEBUG # validate
DEFINITIONS += -DBENCHMARK
# DEFINITIONS += -DTRACE_COMPILE
# DEFINITIONS += -DBUILD_ZOG_MP_COMPILE # active ZOG MP

LIBS = -lpthread
LIBS += -ldl

RobboLito_SOURCES = main.c \
                    arrays.c \
                    SLAB_MEMORY.c \
                    set_position.c \
                    utility.c \
                    material_value.c \
                    pawn_eval.c \
                    evaluation.c \
                    mobility.c \
                    50move.c \
                    MEM_HANDLER.c \
                    Zobrist_init.c \
                    Zobrist_use.c \
                    SEE.c \
                    move_gen.c \
                    make_move.c \
                    un_make_move.c \
                    top_node.c \
                    root_node.c \
                    pv_node.c \
                    cut_node.c \
                    all_node.c \
                    exclude_node.c \
                    control.c \
                    MonteCarlo.c \
                    TopNodeMonteCarlo.c \
                    RootNodeMonteCarlo.c \
                    input.c \
                    search.c \
                    static.c \
                    next_move.c \
                    low_depth.c \
                    qsearch.c \
                    qsearch_pv.c \
                    ok_move.c \
                    signals.c \
                    magic_mult.c 

IVAN_SOURCES = SMP.c \
               SMP_init.c \
               SMP_search.c \
               top_analysis.c \
               root_analysis.c \
               root_multipv.c \
               benchmark.c

RobboLito_SOURCES += $(IVAN_SOURCES)

UTILITY_SOURCES =  matval_explain.c \
                   eval_explain.c \
                   pawn_eval_explain.c \
                   validate.c \
                   perft.c

# DEFINITIONS += -DDEBUG -DUTILITIES # perft # eval explain # Fact: EE slows 3%
RobboLito_SOURCES += $(UTILITY_SOURCES) # comment out

ROBBO_GLUE = Robbo_glue_new.c Robbo_mossa.c

RobboLito_OBJECTS = $(RobboLito_SOURCES:.c=.o) $(ROBBO_GLUE:.c=.o)
RobboAnalysis_OBJECTS = $(RobboLito_OBJECTS:.o=.ao)

INCLUDE = init_gen.i \
          history.i \
          null_move.i \
          material_value.i

ALTRO = Makefile \
        YakovChart.bi \
        YakovChart.ne \
        evaluation.v \
        pawn_eval.v

UTILITY_OBJECTS = $(UTILITY_SOURCES:.c=.o)

SOURCES = $(RobboLito_SOURCES)
TUTTO = $(SOURCES) $(INCLUDE) $(ALTRO) $(ROBBO_GLUE) RobboBaseLibUsage.h

CP = /bin/cp
MKDIR = /bin/mkdir
RM = /bin/rm
SED = /bin/sed
TAR = /bin/tar
WORKING_DIR = $(EPONYM)Source
CD = cd

CFLAGS += $(OPTIONS) $(FLAGS) $(DEFINITIONS)

all: IvanHoe-GamePlay IvanHoe-Analysis
IvanHoe-GamePlay: $(RobboLito_OBJECTS) $(RobboLito_HEADERS) Makefile
	$(CC) $(CFLAGS) -o $(EPONYM)-GamePlay $(RobboLito_OBJECTS) $(LIBS)
IvanHoe-Analysis: $(RobboAnalysis_OBJECTS) $(RobboLito_HEADERS) Makefile
	$(CC) $(CFLAGS) -o $(EPONYM)-Analysis $(RobboAnalysis_OBJECTS) $(LIBS)
%.o: %.c $(RobboLito_HEADERS) Makefile
	$(CC) $(CFLAGS) -DMODE_GAME_PLAY -o $@ -c $<
%.ao: %.c $(RobboLito_HEADERS) Makefile
	$(CC) $(CFLAGS) -DMODE_ANALYSIS -o $@ -c $<

archive:
	$(RM) -rf $(WORKING_DIR) *.tar # ensure
	$(MKDIR) $(WORKING_DIR)
	$(CP) $(TUTTO) $(WORKING_DIR)
	$(TAR) cf $(WORKING_DIR).tar $(WORKING_DIR)/*
	$(RM) -rf $(WORKING_DIR)

clean:
	$(RM) -f *.o *.ao *~ $(EPONYM)-GamePlay $(EPONYM)-Analysis
