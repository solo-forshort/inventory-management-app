from django.contrib import admin
from .models import Category, Product


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'description')
    search_fields = ('name',)


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'sku', 'category', 'unit_price', 'quantity_in_stock', 'reorder_level', 'is_low_stock', 'is_active')
    list_filter = ('category', 'is_active')
    search_fields = ('name', 'sku')
    list_editable = ('quantity_in_stock', 'is_active')

    @admin.display(boolean=True, description='Low stock?')
    def is_low_stock(self, obj):
        return obj.is_low_stock