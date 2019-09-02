from django.urls import path
from kam2do import views
app_name = 'kam2do'

urlpatterns = [
		path('',views.index,name = 'index'),
]


