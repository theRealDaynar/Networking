if buffer_read(ds_grid_get(circularBuffer, 1, cirBuffPosition), argument1) = argument2
{
    buffer_write(argument0, buffer_bool, 0)
    return 0
}
else
{
    buffer_write(argument0, buffer_bool, 1)
    buffer_write(argument0, argument1, argument2)
    return 1
}
