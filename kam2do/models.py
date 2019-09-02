from django.db import models


class ToDo(models.Model):
    title = models.TextField
    description = models.TextField
    isCompleted = models.BooleanField(default=False)

    def __str__(self):
        return str({
            'title': self.title,
            'description': self.description,
            'isCompleted': self.isCompleted
        })
