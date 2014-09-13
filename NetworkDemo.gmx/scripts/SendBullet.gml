        var mBuffer = buffer_create(1, buffer_grow, 1)
        buffer_write(mBuffer, buffer_s16, ADD_BULLET );
        buffer_write(mBuffer, buffer_s32, argument0.id );
        buffer_write(mBuffer, buffer_s16, argument0.x );
        buffer_write(mBuffer, buffer_s16, argument0.y );
        buffer_write(mBuffer, buffer_s16, argument0.direction );
        buffer_write(mBuffer, buffer_s16, argument0.speed );
        var count = ds_list_size(oServer.socketlist);
        if( count>0 )
        {
            for(i=0;i<count;i++)
            { 
                network_send_packet( ds_list_find_value(oServer.socketlist,i),mBuffer, buffer_get_size(mBuffer));
            }
        }
        buffer_delete(mBuffer)
