#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication
{
  GtkApplication parent_instance;
  char **dart_entrypoint_arguments;
  GtkCssProvider *css_provider;
  GdkScreen *screen;
  GtkHeaderBar *header_bar;
  int current_height;
  gchar *transition_speed;
  gchar *current_color; // ready color string
  gchar *button_color;  // ready color string
  gchar *title;
};
G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)
static void method_call_handler(FlMethodChannel *channel,
                                FlMethodCall *method_call,
                                gpointer user_data);
static void changeHeaderWidth(MyApplication *self, FlValue *args);
static void changeColor(MyApplication *self, FlValue *args);
static void update_app_styles(MyApplication *self);

static void update_app_styles(MyApplication *self)
{
  gchar *css = g_strdup_printf(R"(
      headerbar {
        min-height: %dpx;
        %s
        %s
        color: #ffffff;
        border: none;
        box-shadow: none;
      }
      headerbar > box.left,
      headerbar > box.right,
      headerbar > box.center {
          min-height: %dpx;
          padding: 0;
      }
      headerbar:backdrop {
        %s
        color: #ffffff;
      }
      headerbar button {
        %s
        color: #ffffff;
        %s
      }
      headerbar:backdrop button {
        %s
        color: #ffffff;
      }
      headerbar > box {
        padding: 0px;
        margin: 0px;
      }
      headerbar button.titlebutton {
        min-height: %dpx;
        min-width: %dpx;
        padding: 0px;
        margin: 4px;
      }
      windowhandle box {
        padding: 0px;
        min-height: %dpx;
      }
    )", self->current_height, 
    self->current_color, 
    self->transition_speed, 
    self->current_height, 
    self->current_color, 
    self->button_color, 
    self->transition_speed, 
    self->button_color, 
    self->current_height, 
    self->current_height, 
    self->current_height);

  gtk_css_provider_load_from_data(self->css_provider, css, -1, nullptr);
  g_free(css);
}

static void update_title(MyApplication *self, FlValue *args) {
  const gchar *title = fl_value_get_string(fl_value_lookup_string(args, "title"));
  g_free(self->title);
  self->title = g_strdup(title);
  gtk_header_bar_set_title(GTK_HEADER_BAR(self->header_bar), self->title);
  gtk_header_bar_set_title(self->header_bar, self->title);
}

static void changeHeaderWidth(MyApplication *self, FlValue *args)
{
  int header_height = fl_value_get_int(fl_value_lookup_string(args, "height"));
  // g_free(self->current_height);
  self->current_height = header_height;
  update_app_styles(self);
}

static void changeColor(MyApplication *self, FlValue *args)
{
  int r_left = fl_value_get_int(fl_value_lookup_string(args, "r1"));
  int g_left = fl_value_get_int(fl_value_lookup_string(args, "g1"));
  int b_left = fl_value_get_int(fl_value_lookup_string(args, "b1"));

  int r_center = fl_value_get_int(fl_value_lookup_string(args, "r2"));
  int g_center = fl_value_get_int(fl_value_lookup_string(args, "g2"));
  int b_center = fl_value_get_int(fl_value_lookup_string(args, "b2"));

  int r_right = fl_value_get_int(fl_value_lookup_string(args, "r3"));
  int g_right = fl_value_get_int(fl_value_lookup_string(args, "g3"));
  int b_right = fl_value_get_int(fl_value_lookup_string(args, "b3"));

  double transition_speed = fl_value_get_float(fl_value_lookup_string(args, "transition_speed"));

  // old background-color: rgb(%d, %d, %d);
  gchar *gradient = g_strdup_printf(
      "background-image: linear-gradient(to right, rgb(%d, %d, %d), rgb(%d, %d, %d), rgb(%d, %d, %d));",
      r_left, g_left, b_left,
      r_center, g_center, b_center,
      r_right, g_right, b_right);
  gchar *button = g_strdup_printf(
      "background-color: rgb(%d, %d, %d);",
      r_right, g_right, b_right);
  gchar *transition = g_strdup_printf("transition: all %.2fs ease;", transition_speed);
  g_free(self->current_color);
  g_free(self->button_color);
  g_free(self->transition_speed);
  self->current_color = gradient;
  self->transition_speed = transition;
  self->button_color = button;
  update_app_styles(self);
}

static void method_call_handler(FlMethodChannel *channel,
                                FlMethodCall *method_call,
                                gpointer user_data)
{
  MyApplication *self = MY_APPLICATION(user_data);

  if (strcmp(fl_method_call_get_name(method_call), "setHeaderColor") == 0)
  {
    FlValue *args = fl_method_call_get_args(method_call);
    changeColor(self, args);
    fl_method_call_respond_success(method_call, nullptr, nullptr);
  }
  else if (strcmp(fl_method_call_get_name(method_call), "setHeaderWidth") == 0)
  {
    FlValue *args = fl_method_call_get_args(method_call);
    changeHeaderWidth(self, args);
    fl_method_call_respond_success(method_call, nullptr, nullptr);
  } else if (strcmp(fl_method_call_get_name(method_call), "setHeaderTitle") == 0) {
    FlValue *args = fl_method_call_get_args(method_call);
    update_title(self, args);
  }
  else
  {
    fl_method_call_respond_not_implemented(method_call, nullptr);
  }
}

// Implements GApplication::activate.
static void my_application_activate(GApplication *application)
{
  MyApplication *self = MY_APPLICATION(application);
  GtkWindow *window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen *screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen))
  {
    const gchar *wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0)
    {
      use_header_bar = FALSE;
    }
  }
#endif

  self->screen = gtk_window_get_screen(window);

  if (use_header_bar)
  {
    GtkHeaderBar *header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    self->header_bar = header_bar;
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "quark");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  }
  else
  {
    gtk_window_set_title(window, "quark");
  }

  self->css_provider = gtk_css_provider_new();
  self->current_height = 32;
  self->current_color = g_strdup("background-image: linear-gradient(to right, rgb(24, 24, 26));");
  self->button_color = g_strdup("background-image: linear-gradient(to right, rgb(24, 24, 26));");
  self->transition_speed = g_strdup("transition: all 0.3s ease;");
  // default
  const char *css = R"(
    headerbar {
      background-color: #222226;
      color: #ffffff;
      border: none;
      box-shadow: none;  
      min-height: 32px;
      background-image: none;
    }
    headerbar:backdrop {
      background-color: #222226;  
      background-image: none;
      color: #ffffff;
    }
    windowhandle box {
      padding-top: 0px;
      padding-bottom: 0px;
    }
    headerbar button.titlebutton {
      min-height: 24px;
      min-width: 24px;
      margin-top: 2px;
      margin-bottom: 2px;
      padding: 0px;
    }
    headerbar button {
      background-color: #222226;
      color: #ffffff;
    }
    headerbar:backdrop button {
      background-color: #222226;
      color: #ffffff;
    }
  )";

  gtk_css_provider_load_from_data(self->css_provider, css, -1, nullptr);

  gtk_style_context_add_provider_for_screen(
      self->screen,
      GTK_STYLE_PROVIDER(self->css_provider),
      GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);

  gtk_window_set_default_size(window, 850, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView *view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  // flutter
  FlBinaryMessenger *messenger =
      fl_engine_get_binary_messenger(fl_view_get_engine(view));
  FlMethodChannel *channel = fl_method_channel_new(
      messenger,
      "app/window_style",
      FL_METHOD_CODEC(fl_standard_method_codec_new()));

  fl_method_channel_set_method_call_handler(channel, method_call_handler, self, nullptr);

  gtk_widget_grab_focus(GTK_WIDGET(view));
}
// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication *application, gchar ***arguments, int *exit_status)
{
  MyApplication *self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error))
  {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication *application)
{
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication *application)
{
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject *object)
{
  MyApplication *self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  // Освобождаем provider при закрытии приложения
  g_clear_object(&self->css_provider);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}
static void my_application_class_init(MyApplicationClass *klass)
{
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication *self) {}

MyApplication *my_application_new()
{
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_NON_UNIQUE,
                                     nullptr));
}