def scrub_output_pre_save(model, **kwargs):
    """scrub output before saving notebooks"""

    import os

    # only run on notebooks
    if model['type'] != 'notebook':
        return

    # only run on nbformat v4
    if model['content']['nbformat'] != 4:
        return

    # only run for arc kernel
    if not 'metadata' in model['content']:
        return

    if not 'kernelspec' in model['content']['metadata']:
        return

    if not 'name' in model['content']['metadata']['kernelspec']:
        return

    if model['content']['metadata']['kernelspec']['name'] != 'arc':
        return

    # allow save data override which is useful for preparing examples
    if 'JUPYTER_SAVE_OUTPUT' in os.environ:
        if os.environ['JUPYTER_SAVE_OUTPUT'].lower() == 'true':
            return

    # clear all cell_type=code cells
    for cell in model['content']['cells']:
        if cell['cell_type'] != 'code':
            continue
        cell['outputs'] = []
        cell['execution_count'] = None
        cell['metadata'] = {}


c.FileContentsManager.pre_save_hook = scrub_output_pre_save
