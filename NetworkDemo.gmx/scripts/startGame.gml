for(var i=0;i<global.PlayerTotal;i++)
{
    with(oPlayer)
    {
        if client=false
        {
            x=random(room_width)
            y=random(room_height)
            while(GetCollision(x,y)!=-1)
            {
                x=random(room_width)
                y=random(room_height)
            }
            ghost=false
            with(oServerProjectile)
                instance_destroy()
        }
    }
}
playing = true
alarm[3]=room_speed*5
pause=true
/*
global.pBuffer = buffer_create(1, buffer_grow, 1)
buffer_write(global.pBuffer, buffer_s16, 13);
var count = ds_list_size(socketlist);
if( count>0 )
{
    for(i=0;i<count;i++)
    {
        network_send_packet( ds_list_find_value(socketlist,i), global.pBuffer, buffer_get_size(global.pBuffer));
    }
}
buffer_delete(global.pBuffer)
