class Hq::PendingOrphanListsController < HqController

  def upload
    get_partner

    unless @partner.active?
      flash[:error] = 'Partner is not Active. Orphan List cannot be uploaded.'
      redirect_to hq_partner_path(@partner)
      return
    end
  end

  def validate
    get_partner

    unless @partner.active?
      flash[:alert] = 'Partner is not Active. Orphan List cannot be uploaded.'
      redirect_to hq_partner_path(@partner)
      return
    end

    if params['pending_orphan_list'].nil?  # no spreadsheet has been specified
      flash[:error] = 'Please specify the spreadsheet to be uploaded'
      redirect_to upload_hq_partner_pending_orphan_lists_path(@partner)
      return
    end

    @pending_orphan_list = PendingOrphanList.new(pending_orphan_list_params)
    importer = OrphanImporter.new(params['pending_orphan_list']['spreadsheet'], @partner)
    result = importer.extract_orphans

    if importer.valid?
      @pending_orphan_list.pending_orphans = result
      @pending_orphan_list.save!
      to_render = :valid_list
    else
      to_render = :invalid_list
    end

    render action: to_render,
           locals: { partner:             @partner,
                     orphan_list:         @partner.orphan_lists.build,
                     pending_orphan_list: @pending_orphan_list,
                     result:              result }
  end

private

  def get_partner
    @partner = Partner.find(params[:partner_id])
  end

  def pending_orphan_list_params
    params.require(:pending_orphan_list).permit(:spreadsheet)
  end

  def get_pending_orphan_list
    @pending_orphan_list = PendingOrphanList.find(params[:orphan_list][:pending_id])
  end

end