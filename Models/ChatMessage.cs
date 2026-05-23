using System;

namespace LTWEB_QuaMonHai_CuoiKy.Models;

public partial class ChatMessage
{
    public int Id { get; set; }

    public string ChatRoomId { get; set; } = null!;

    public string SenderId { get; set; } = null!;

    public string SenderName { get; set; } = null!;

    public string Message { get; set; } = null!;

    public DateTime Timestamp { get; set; }

    public bool IsFromCustomer { get; set; }

    public bool IsRead { get; set; }
}
